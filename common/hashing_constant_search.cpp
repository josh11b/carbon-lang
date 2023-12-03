// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include "absl/random/random.h"
#include "common/ostream.h"
#include "llvm/Support/FormatVariadic.h"

auto main() -> int {
  const uint64_t minc = 0x517cc1b727220a95;
  const uint64_t maxc = 0x9e3779b97f4a7c15;
  const uint64_t delta = (maxc - minc) / 2;
  const int low_zero_bits = 0;
  absl::BitGen gen;

  int best_n = 17;
  uint64_t best_score = 1ull << (36 - 18);
  while (true) {
    uint64_t c = absl::Uniform<uint64_t>(gen, 0, delta) * 2 + minc;
    // llvm::errs() << "c: " << llvm::formatv("{0:x16}", c) << "\n";
    int mn0 = 0;
    int mn1 = 0;
    uint64_t witness0 = 0;
    uint64_t witness1 = 0;
    bool good = true;
    for (uint64_t i = 1; i < 0x10000; ++i) {
      // Compute the hash
      uint64_t h = c * (i << low_zero_bits);

      // Find `n0`/`n1`, the maximum number of zero/one bits in a row in bits
      // 24..56 of `h`.
      int n0 = 0;
      int c0 = 0;
      int n1 = 0;
      int c1 = 0;
      for (int j = 24; j < 57; ++j) {
        if ((h & (1ull << j)) == 0) {
          ++c0;
          if (c1 > n1) {
            n1 = c1;
          }
          c1 = 0;
        } else {
          if (c0 > n0) {
            n0 = c0;
          }
          c0 = 0;
          ++c1;
        }
      }
      if (c0 > n0) {
        n0 = c0;
      }
      if (c1 > n1) {
        n1 = c1;
      }

      // `mn0` is the maximum of `n0` over `i`
      if (n0 > mn0) {
        mn0 = n0;
        // Since we test in order of increasing `i`, this is the minimum
        // `i` that achieves this number of zeros.
        witness0 = i;
        // Don't consider anything that has more than 2 more zero bits in a
        // row than the best scoring constant we've found so far.
        if (n0 > best_n + 2) {
          good = false;
          break;
        }
      }
      if (n1 > mn1) {
        mn1 = n1;
        witness1 = i;
        if (n1 > best_n + 2) {
          good = false;
          break;
        }
      }
    }
    if (good) {
      // We are maximizing score, which aims for a larger witness0/1 value
      // and a smaller maximum-number-of-zero/one-bits-in-a-row. Twice as big
      // a witness0 is as good as one fewer zero-bits-in-a-row.
      uint64_t score0 = witness0 << (36 - mn0);
      uint64_t score1 = witness1 << (36 - mn1);
      uint64_t score = std::min(score0, score1);
      // Print things close to the best score even if they are not better.
      if (score + (score >> 1) > best_score) {
        llvm::errs() << llvm::formatv("{0:x16}", c) << " * "
                     << llvm::formatv("{0:x}", witness0) << " << "
                     << low_zero_bits << " = "
                     << llvm::formatv("{0:x16}", c * witness0 << low_zero_bits)
                     << " has " << mn0 << " zeros in a row\n";
        llvm::errs() << "                   * "
                     << llvm::formatv("{0:x}", witness1) << " << "
                     << low_zero_bits << " = "
                     << llvm::formatv("{0:x16}", c * witness1 << low_zero_bits)
                     << " has " << mn1 << " ones in a row\n";
        llvm::errs().flush();
      }
      if (score > best_score) {
        best_score = score;
        best_n = std::min(std::max(mn0, mn1), best_n);
      }
    }
  }
}
