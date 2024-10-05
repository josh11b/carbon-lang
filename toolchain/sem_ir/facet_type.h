// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef CARBON_TOOLCHAIN_SEM_IR_FACET_TYPE_H_
#define CARBON_TOOLCHAIN_SEM_IR_FACET_TYPE_H_

namespace Carbon::SemIR {

struct FacetType : Printable<FacetType> {
  // TODO: Need to switch to a processed, canonical form.
  TypeId base_facet_type_id;
  InstBlockId requirement_block_id;

  auto Print(llvm::raw_ostream& out) const -> void {
    out << "{facet_type: " << base_facet_type_id
        << ", requirements: " << requirement_block_id << "}";
  }
  // TODO: Implement hash and ==
};

}  // namespace Carbon::SemIR

#endif  // CARBON_TOOLCHAIN_SEM_IR_FACET_TYPE_H_
