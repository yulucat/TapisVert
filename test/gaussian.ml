open Seq

(** Knuth algorithm for producing a sample from N(0,1) *)
let random_normal : float Seq.t =
  let rec gen phase () =
    let u1 = Random.float 1.0 in
    let u2 = Random.float 1.0 in
    let v1 = 2. *. u1 -. 1.0 in
    let v2 = 2. *. u2 -. 1.0 in
    let s = v1 *. v1 +. v2 *. v2 in
    if s >= 1.0 || s = 0.0 then
      gen phase ()
    else
      l