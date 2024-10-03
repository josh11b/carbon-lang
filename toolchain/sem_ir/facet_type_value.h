// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef CARBON_TOOLCHAIN_SEM_IR_FACET_TYPE_VALUE_H_
#define CARBON_TOOLCHAIN_SEM_IR_FACET_TYPE_VALUE_H_

namespace Carbon::SemIR {

struct FacetTypeValue : Printable<FacetTypeValue> {
  // `==` requirements
  struct EquivalentRequirement {
    // FIXME: LHS
    // FIXME: RHS
  };
  llvm::SmallVector<EquivalentRequirement, 0> equivs_;

  // `impls` requirements
  struct ImplsRequirement {
    // What must satisfy the requirement
    TypeId type_id;
    // The FacetTyep that type must implement
    FacetTypeValueId must_impl_id;
  };
  llvm::SmallVector<ImplsRequirement, 0> impls_;

  // `.X = ...` requirements
  struct RewriteRequirement {
    // FIXME: LHS
    // FIXME: RHS
  };
  llvm::SmallVector<RewriteRequirement, 0> rewrites_;

  // Names
  // FIXME: ?

  auto Print(llvm::raw_ostream& out) const -> void {
    // FIXME: out << "{inst: " << inst_id << ", generic: " << generic_id
    //            << ", index: " << index << "}";
  }
  // FIXME: hash and ==
};

}  // namespace Carbon::SemIR

#endif  // CARBON_TOOLCHAIN_SEM_IR_FACET_TYPE_VALUE_H_
