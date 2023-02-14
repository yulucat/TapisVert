
(* In this test, we measure the error between the true quantiles of
   data, and the quantiles as computed through the [Bentov] histogram
   approximation module. The data is drawn from a mixture of two
   Gaussians, N(2,1) and N(5,1), where the mixing coefficient is 1/2.
   We compute the approximate quantiles in two ways: In the frist, we
   simply add each sample into a [Bentov.histogram]. We call this
   histogram [mixed]. In the second, we add a datum to one of two
   [Bentov.histogram]'s, one associated with each of the Guassians. We
   then merge these two histograms using [Bentov.merge]. We call the
   result of merging the two sub-histograms [merged]. Finally, we
   compute and print the mean-square-error between the true quantiles
   and [mixed], and the true quantiles and [merged]. *)

(* [quantiles list num_intervals] returns the quantiles (true, not
   approximated) of list [list] at [num_intervals + 1] points, including
   the minimum and maximum values (which are the first and last values of
   the result, resp. *)
let quantiles =
  let rec loop i j span accu = function
    | x0 :: x1 :: rest ->
      let s = (float j) *. span in
      if i <= s && s < i +. 1. then
        let d = s -. i in
        let x_d = (x1 -. x0) *. d +. x0 in
        loop i (j + 1) span ((j, x_d) :: accu) (x0 :: x1 :: rest)
      else
        loop (i +. 1.) j span accu (x1 :: rest)

    | [x] ->
      let x_d = j, x in
      List.rev (x_d :: accu)

    | [] -> assert false
  in
  fun x m ->
    let x_sorted = List.sort Stdlib.compare x in
    let n = List.length x_sorted in
    let span = (float n) /. (float m) in
    loop 0. 0 span [] x_sorted


open Seq

(** [up_to n seq] returns a sequence that echos at most [n] values of
    sequence [seq] *)
let up_to =
  let rec loop i n seq () =
    if i = n then
      Nil
    else
      match seq () with
      | Nil -> Nil
      | Cons (v, seq) ->
        Cons (v, loop (i + 1) n seq)
  in
  fun n seq ->
    if n < 0 then
      raise (Invalid_argument "up_to")
    else
      loop 0 n seq

module IntMap = Map.Make(Int)

let map_of_assoc assoc =
  List.fold_left (
    fun k_to_v (k, v) ->
      IntMap.add k v k_to_v
  ) IntMap.empty assoc

let _ =
  (* the number of data to draw *)