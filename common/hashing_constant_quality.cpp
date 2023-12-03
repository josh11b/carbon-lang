// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include <string>

#include "common/ostream.h"
#include "llvm/Support/FormatVariadic.h"

auto main(int argc, char* argv[]) -> int {
  int low_zero_bits = 0;
  // 2^54/phi
  uint64_t c = 0x9e3779b97f4a7c15ull;

  // the number Rust uses
  // uint64_t c = 0x517cc1b727220a95ull;

  // works well in practice
  // uint64_t c = 0x7924f9e0de1e8cf5ull;

  // Gets only 1 zero in a row, but isn't a good hash
  // uint64_t c = 0x5555555555555555ull;

  // From Richard, works well
  // uint64_t c = 0xDCB22CA68CB134EDull;

  if (argc > 1) {
    c = std::stoull(argv[1], nullptr, 16);
    if (argc > 2) {
      low_zero_bits = std::stoull(argv[2]);
    }
  }

  llvm::errs() << "c: " << llvm::formatv("{0:x16}", c) << "\n";
  int mn0 = 0;
  int mn1 = 0;
  for (uint64_t i = 1; i < 0x100000; ++i) {
    // Compute the hash
    uint64_t h = c * (i << low_zero_bits);

    // Find `n0`, the maximum number of zero bits in a row in bits
    // 24..56 of `h`.
    int n0 = 0;
    int c0 = 0;
    // `n1` has the maximum number of one bits in a row of `h`
    int n1 = 0;
    int c1 = 1;
    for (int j = 24; j < 57; ++j) {
      if ((h & (1ull << j)) == 0) {
        ++c0;
        if (c1 > n1) {
          n1 = c1;
        }
        c1 = 0;
      } else {
        ++c1;
        if (c0 > n0) {
          n0 = c0;
        }
        c0 = 0;
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
      llvm::errs() << llvm::formatv("{0:x16}", c) << " * "
                   << llvm::formatv("{0:x}", i) << " << " << low_zero_bits
                   << " = " << llvm::formatv("{0:x16}", c * i << low_zero_bits)
                   << " has " << mn0 << " zeros in a row\n";
      llvm::errs().flush();
    }

    // `mn1` is the maximum of `n1` over `i`
    if (n1 > mn1) {
      mn1 = n1;
      llvm::errs() << llvm::formatv("{0:x16}", c) << " * "
                   << llvm::formatv("{0:x}", i) << " << " << low_zero_bits
                   << " = " << llvm::formatv("{0:x16}", c * i << low_zero_bits)
                   << " has " << mn1 << " ones in a row\n";
      llvm::errs().flush();
    }
  }
}
