
(** Definitions taken from:
    flambda2:middle_end/flambda/inlining/inlining_report.ml
    without whanges *)

type at_call_site =
  | Unknown_function
  | Non_inlinable_function of {
      code_id : Code_id.t;
    }
  | Inlinable_function of {
      code_id : Code_id.t;
      decision : Inlining_decision.Call_site_decision.t;
    }
[@@deriving yojson]

type fundecl_pass =
  | Before_simplify
  | After_simplify
[@@deriving yojson]

type at_function_declaration = {
  pass : fundecl_pass;
  code_id : Code_id.t;
  decision : Inlining_decision.Function_declaration_decision.t;
} [@@deriving yojson]

type decision =
  | At_call_site of at_call_site
  | At_function_declaration of at_function_declaration
[@@deriving yojson]

type t = {
  dbg : Debuginfo.t;
  decision : decision;
}
[@@deriving yojson]

type metadata = {
  compilation_unit : Compilation_unit.t;
} [@@deriving yojson]

type report = [ `Flambda2_1_0_0 of metadata * t list ][@@deriving yojson]


(* Conversion function *)
(* ******************* *)

let conv_callsite t : Ocir_core.Call_site_decision.t =
  match (t: at_call_site) with
  | Unknown_function -> Unknown_function
  | Non_inlinable_function { code_id; } ->
    let code_id = Code_id.conv code_id in
    let decision : Ocir_core.Call_site_decision.decision =
      Unchanged(Flambda2, Forbidden_by_decision_at_declaration)
    in
    Known_function { code_id; decision; }
  | Inlinable_function { code_id; decision; } ->
    let code_id = Code_id.conv code_id in
    let decision = Inlining_decision.conv_callsite decision in
    Known_function { code_id; decision; }


