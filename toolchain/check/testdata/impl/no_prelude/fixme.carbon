// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/impl/no_prelude/fixme.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/impl/no_prelude/fixme.carbon


// --- fail_todo_symbolic_associated_type_in_concrete_context.carbon
library "[[@TEST_NAME]]";

interface Z {
  let X:! type;
}

class C(T:! type) {}
class D {}

impl forall [T:! type] T as Z where .X = C(T) {}

fn F() {
  // TODO: `D.(Z.X)` is `C(D)`, but is incorrecty treated only as the symbolic
  // `C(T)` here which fails to convert.

  // CHECK:STDERR: fail_todo_symbolic_associated_type_in_concrete_context.carbon:[[@LINE+4]]:20: error: `Core.ImplicitAs` implicitly referenced here, but package `Core` not found [CoreNotFound]
  // CHECK:STDERR:   let a: D.(Z.X) = {} as C(D);
  // CHECK:STDERR:                    ^~~~~~~~~~
  // CHECK:STDERR:
  let a: D.(Z.X) = {} as C(D);
}

// CHECK:STDOUT: --- fail_todo_symbolic_associated_type_in_concrete_context.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Z.type: type = facet_type <@Z> [concrete]
// CHECK:STDOUT:   %Self: %Z.type = bind_symbolic_name Self, 0 [symbolic]
// CHECK:STDOUT:   %Z.assoc_type: type = assoc_entity_type %Z.type [concrete]
// CHECK:STDOUT:   %assoc0: %Z.assoc_type = assoc_entity element0, @Z.%X [concrete]
// CHECK:STDOUT:   %T: type = bind_symbolic_name T, 0 [symbolic]
// CHECK:STDOUT:   %T.patt: type = symbolic_binding_pattern T, 0 [symbolic]
// CHECK:STDOUT:   %C.type: type = generic_class_type @C [concrete]
// CHECK:STDOUT:   %C.generic: %C.type = struct_value () [concrete]
// CHECK:STDOUT:   %C.f2e: type = class_type @C, @C(%T) [symbolic]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [concrete]
// CHECK:STDOUT:   %complete_type.357: <witness> = complete_type_witness %empty_struct_type [concrete]
// CHECK:STDOUT:   %D: type = class_type @D [concrete]
// CHECK:STDOUT:   %.Self: %Z.type = bind_symbolic_name .Self [symbolic_self]
// CHECK:STDOUT:   %.Self.as_type: type = facet_access_type %.Self [symbolic_self]
// CHECK:STDOUT:   %.Self.as_wit.iface0: <witness> = facet_access_witness %.Self, element0 [symbolic_self]
// CHECK:STDOUT:   %Z.facet.bf2: %Z.type = facet_value %.Self.as_type, (%.Self.as_wit.iface0) [symbolic_self]
// CHECK:STDOUT:   %impl.elem0: type = impl_witness_access %.Self.as_wit.iface0, element0 [symbolic_self]
// CHECK:STDOUT:   %Z_where.type.b30: type = facet_type <@Z where %impl.elem0 = %C.f2e> [symbolic]
// CHECK:STDOUT:   %require_complete.f02: <witness> = require_complete_type %Z_where.type.b30 [symbolic]
// CHECK:STDOUT:   %impl_witness.00e: <witness> = impl_witness (%C.f2e), @impl(%T) [symbolic]
// CHECK:STDOUT:   %F.type: type = fn_type @F [concrete]
// CHECK:STDOUT:   %F: %F.type = struct_value () [concrete]
// CHECK:STDOUT:   %C.131: type = class_type @C, @C(%D) [concrete]
// CHECK:STDOUT:   %Z_where.type.116: type = facet_type <@Z where %impl.elem0 = %C.131> [concrete]
// CHECK:STDOUT:   %complete_type.fc8: <witness> = complete_type_witness %Z_where.type.116 [concrete]
// CHECK:STDOUT:   %impl_witness.b6f: <witness> = impl_witness (%C.f2e), @impl(%D) [concrete]
// CHECK:STDOUT:   %Z.facet.94c: %Z.type = facet_value %D, (%impl_witness.b6f) [concrete]
// CHECK:STDOUT:   %C.val: %C.131 = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [concrete] {
// CHECK:STDOUT:     .Z = %Z.decl
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:     .D = %D.decl
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Z.decl: type = interface_decl @Z [concrete = constants.%Z.type] {} {}
// CHECK:STDOUT:   %C.decl: %C.type = class_decl @C [concrete = constants.%C.generic] {
// CHECK:STDOUT:     %T.patt.loc7_9.1: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc7_9.2 (constants.%T.patt)]
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.loc7_9.1: type = bind_symbolic_name T, 0 [symbolic = %T.loc7_9.2 (constants.%T)]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %D.decl: type = class_decl @D [concrete = constants.%D] {} {}
// CHECK:STDOUT:   impl_decl @impl [concrete] {
// CHECK:STDOUT:     %T.patt.loc10_14.1: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc10_14.2 (constants.%T.patt)]
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.ref.loc10_24: type = name_ref T, %T.loc10_14.1 [symbolic = %T.loc10_14.2 (constants.%T)]
// CHECK:STDOUT:     %Z.ref: type = name_ref Z, file.%Z.decl [concrete = constants.%Z.type]
// CHECK:STDOUT:     %.Self: %Z.type = bind_symbolic_name .Self [symbolic_self = constants.%.Self]
// CHECK:STDOUT:     %.Self.ref: %Z.type = name_ref .Self, %.Self [symbolic_self = constants.%.Self]
// CHECK:STDOUT:     %X.ref: %Z.assoc_type = name_ref X, @X.%assoc0 [concrete = constants.%assoc0]
// CHECK:STDOUT:     %.Self.as_type: type = facet_access_type %.Self.ref [symbolic_self = constants.%.Self.as_type]
// CHECK:STDOUT:     %.loc10_37: type = converted %.Self.ref, %.Self.as_type [symbolic_self = constants.%.Self.as_type]
// CHECK:STDOUT:     %.Self.as_wit.iface0: <witness> = facet_access_witness %.Self.ref, element0 [symbolic_self = constants.%.Self.as_wit.iface0]
// CHECK:STDOUT:     %impl.elem0: type = impl_witness_access %.Self.as_wit.iface0, element0 [symbolic_self = constants.%impl.elem0]
// CHECK:STDOUT:     %C.ref: %C.type = name_ref C, file.%C.decl [concrete = constants.%C.generic]
// CHECK:STDOUT:     %T.ref.loc10_44: type = name_ref T, %T.loc10_14.1 [symbolic = %T.loc10_14.2 (constants.%T)]
// CHECK:STDOUT:     %C.loc10_45.1: type = class_type @C, @C(constants.%T) [symbolic = %C.loc10_45.2 (constants.%C.f2e)]
// CHECK:STDOUT:     %.loc10_31: type = where_expr %.Self [symbolic = %Z_where.type (constants.%Z_where.type.b30)] {
// CHECK:STDOUT:       requirement_rewrite %impl.elem0, %C.loc10_45.1
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %T.loc10_14.1: type = bind_symbolic_name T, 0 [symbolic = %T.loc10_14.2 (constants.%T)]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %impl_witness: <witness> = impl_witness (constants.%C.f2e), @impl(constants.%T) [symbolic = @impl.%impl_witness (constants.%impl_witness.00e)]
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [concrete = constants.%F] {} {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @Z {
// CHECK:STDOUT:   %Self: %Z.type = bind_symbolic_name Self, 0 [symbolic = constants.%Self]
// CHECK:STDOUT:   %X: type = assoc_const_decl @X [concrete] {
// CHECK:STDOUT:     %assoc0: %Z.assoc_type = assoc_entity element0, @Z.%X [concrete = constants.%assoc0]
// CHECK:STDOUT:   }
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = %Self
// CHECK:STDOUT:   .X = @X.%assoc0
// CHECK:STDOUT:   witness = (%X)
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic assoc_const @X(@Z.%Self: %Z.type) {
// CHECK:STDOUT:   assoc_const X:! type;
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic impl @impl(%T.loc10_14.1: type) {
// CHECK:STDOUT:   %T.loc10_14.2: type = bind_symbolic_name T, 0 [symbolic = %T.loc10_14.2 (constants.%T)]
// CHECK:STDOUT:   %T.patt.loc10_14.2: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc10_14.2 (constants.%T.patt)]
// CHECK:STDOUT:   %C.loc10_45.2: type = class_type @C, @C(%T.loc10_14.2) [symbolic = %C.loc10_45.2 (constants.%C.f2e)]
// CHECK:STDOUT:   %Z_where.type: type = facet_type <@Z where constants.%impl.elem0 = %C.loc10_45.2 (constants.%C.f2e)> [symbolic = %Z_where.type (constants.%Z_where.type.b30)]
// CHECK:STDOUT:   %require_complete: <witness> = require_complete_type @impl.%Z_where.type (%Z_where.type.b30) [symbolic = %require_complete (constants.%require_complete.f02)]
// CHECK:STDOUT:   %impl_witness: <witness> = impl_witness (constants.%C.f2e), @impl(%T.loc10_14.2) [symbolic = %impl_witness (constants.%impl_witness.00e)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   impl: %T.ref.loc10_24 as %.loc10_31 {
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     witness = file.%impl_witness
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @C(%T.loc7_9.1: type) {
// CHECK:STDOUT:   %T.loc7_9.2: type = bind_symbolic_name T, 0 [symbolic = %T.loc7_9.2 (constants.%T)]
// CHECK:STDOUT:   %T.patt.loc7_9.2: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc7_9.2 (constants.%T.patt)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     %complete_type: <witness> = complete_type_witness %empty_struct_type [concrete = constants.%complete_type.357]
// CHECK:STDOUT:     complete_type_witness = %complete_type
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = constants.%C.f2e
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @D {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [concrete = constants.%complete_type.357]
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%D
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %a.patt: %C.f2e = binding_pattern a
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %.loc20_21.1: %empty_struct_type = struct_literal ()
// CHECK:STDOUT:   %C.ref: %C.type = name_ref C, file.%C.decl [concrete = constants.%C.generic]
// CHECK:STDOUT:   %D.ref.loc20_28: type = name_ref D, file.%D.decl [concrete = constants.%D]
// CHECK:STDOUT:   %C: type = class_type @C, @C(constants.%D) [concrete = constants.%C.131]
// CHECK:STDOUT:   %.loc20_21.2: ref %C.131 = temporary_storage
// CHECK:STDOUT:   %.loc20_21.3: init %C.131 = class_init (), %.loc20_21.2 [concrete = constants.%C.val]
// CHECK:STDOUT:   %.loc20_21.4: ref %C.131 = temporary %.loc20_21.2, %.loc20_21.3
// CHECK:STDOUT:   %.loc20_23.1: ref %C.131 = converted %.loc20_21.1, %.loc20_21.4
// CHECK:STDOUT:   %.loc20_11.1: type = splice_block %impl.elem0 [symbolic = constants.%C.f2e] {
// CHECK:STDOUT:     %D.ref.loc20_10: type = name_ref D, file.%D.decl [concrete = constants.%D]
// CHECK:STDOUT:     %Z.ref: type = name_ref Z, file.%Z.decl [concrete = constants.%Z.type]
// CHECK:STDOUT:     %X.ref: %Z.assoc_type = name_ref X, @X.%assoc0 [concrete = constants.%assoc0]
// CHECK:STDOUT:     %Z.facet: %Z.type = facet_value constants.%D, (constants.%impl_witness.b6f) [concrete = constants.%Z.facet.94c]
// CHECK:STDOUT:     %.loc20_11.2: %Z.type = converted %D.ref.loc20_10, %Z.facet [concrete = constants.%Z.facet.94c]
// CHECK:STDOUT:     %as_wit.iface0: <witness> = facet_access_witness %.loc20_11.2, element0 [concrete = constants.%impl_witness.b6f]
// CHECK:STDOUT:     %impl.elem0: type = impl_witness_access %as_wit.iface0, element0 [symbolic = constants.%C.f2e]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %.loc20_23.2: %C.f2e = converted %.loc20_23.1, <error> [concrete = <error>]
// CHECK:STDOUT:   %a: %C.f2e = bind_name a, <error>
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @X(constants.%Self) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%T) {
// CHECK:STDOUT:   %T.loc7_9.2 => constants.%T
// CHECK:STDOUT:   %T.patt.loc7_9.2 => constants.%T
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @X(constants.%Z.facet.bf2) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @impl(constants.%T) {
// CHECK:STDOUT:   %T.loc10_14.2 => constants.%T
// CHECK:STDOUT:   %T.patt.loc10_14.2 => constants.%T
// CHECK:STDOUT:   %C.loc10_45.2 => constants.%C.f2e
// CHECK:STDOUT:   %Z_where.type => constants.%Z_where.type.b30
// CHECK:STDOUT:   %require_complete => constants.%require_complete.f02
// CHECK:STDOUT:   %impl_witness => constants.%impl_witness.00e
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(@impl.%T.loc10_14.2) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @impl(%T.loc10_14.2) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @impl(constants.%D) {
// CHECK:STDOUT:   %T.loc10_14.2 => constants.%D
// CHECK:STDOUT:   %T.patt.loc10_14.2 => constants.%D
// CHECK:STDOUT:   %C.loc10_45.2 => constants.%C.131
// CHECK:STDOUT:   %Z_where.type => constants.%Z_where.type.116
// CHECK:STDOUT:   %require_complete => constants.%complete_type.fc8
// CHECK:STDOUT:   %impl_witness => constants.%impl_witness.b6f
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%D) {
// CHECK:STDOUT:   %T.loc7_9.2 => constants.%D
// CHECK:STDOUT:   %T.patt.loc7_9.2 => constants.%D
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @X(constants.%Z.facet.94c) {}
// CHECK:STDOUT:
