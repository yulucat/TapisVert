open Seq

(** Knuth algorithm for producing a sample from N(0,1) *)
let random_normal : float Seq.t =
  let rec gen phase () =
    let u1 = R