
(** Definition taken from:
    flambda2:middle_end/flambda/compilenv_deps/linkage_name.ml
    where it is defined as
    [type t = string] *)

type t = string [@@deriving yojson]

(* Conversion function *)
(* ******************* *)

let conv (t: t) : Ocir_core.Linkage_name.t = t


