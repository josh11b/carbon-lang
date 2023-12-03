// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include <algorithm>

#include "absl/random/random.h"
#include "common/ostream.h"
#include "llvm/Support/FormatVariadic.h"

auto main() -> int {
  const int low_zero_bits = 0;
  absl::BitGen gen;
  unsigned char nibbles[16];
  for (int k = 0; k < 16; ++k) {
    nibbles[k] = k;
  }
  int best_nz = 17;
  uint64_t best_score = 1ull << (36 - 18);
  while (true) {
    // Generate a random permutation of the nibbles 0..F as the constant
    for (int k = 0; k < 15; ++k) {
      int l = absl::Uniform<int>(gen, k, 16);
      std::swap(nibbles[k], nibbles[l]);
    }
    uint64_t c = 0;
    for (int k = 0; k < 16; ++k) {
      c = (c << 4) | nibbles[k];
    }

    // llvm::errs() << "c: " << llvm::formatv("{0:x16}", c) << "\n";
    int mnz = 0;
    uint64_t witness = 0;
    bool good = true;
    for (uint64_t i = 1; i < 0x10000; ++i) {
      // Compute the hash
      uint64_t h = c * (i << low_zero_bits);

      // Find `nz`, the maximum number of zero bits in a row in bits
      // 24..56 of `h`.
      int nz = 0;
      int a = 0;
      for (int j = 24; j < 57; ++j) {
        if ((h & (1ull << j)) == 0) {
          ++a;
        } else {
          if (a > nz) {
            nz = a;
          }
          a = 0;
        }
      }
      if (a > nz) {
        nz = a;
      }

      // `mnz` is the maximum of `nz` over `i`
      if (nz > mnz) {
        mnz = nz;
        // Since we test in order of increasing `i`, this is the minimum
        // `i` that achieves this number of zeros.
        witness = i;
        // Don't consider anything that has more than 2 more zero bits in a
        // row than the best scoring constant we've found so far.
        if (nz > best_nz + 2) {
          good = false;
          break;
        }
      }
    }
    if (good) {
      // We are maximizing score, which aims for a larger witness value
      // and a smaller maximum-number-of-zero-bits-in-a-row. Twice as big
      // a witness is as good as one fewer zero-bits-in-a-row.
      uint64_t score = witness << (36 - mnz);
      // Print things close to the best score even if they are not better.
      if (score + (score >> 1) > best_score) {
        llvm::errs() << llvm::formatv("{0:x16}", c) << " * "
                     << llvm::formatv("{0:x}", witness) << " << "
                     << low_zero_bits << " = "
                     << llvm::formatv("{0:x16}", c * witness << low_zero_bits)
                     << " has " << mnz << " zeros in a row\n";
        llvm::errs().flush();
      }
      if (score > best_score) {
        best_score = score;
        best_nz = mnz;
      }
    }
  }
}
