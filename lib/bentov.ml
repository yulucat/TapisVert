
type bin = {
  center : float;
  count : int
}

type histogram = {
  max_bins : int;
  num_bins : int;
  bins : bin list;
  range : (float * float) option; (* (min * max) *)
  total_count : int;
}

let max_bins h =
  h.max_bins

let num_bins h =
  h.num_bins

let bins h =
  h.bins

let range h =
  h.range

let total_count h =
  h.total_count

(* not tail rec! *)
let rec insert value = function
  | [] -> [{ center = value ; count = 1 }], true
  | h :: t ->
    if value < h.center then
      { center = value ; count = 1 } :: h :: t, true
    else if value = h.center then
      { h with count = h.count + 1 } :: t, false
    else
      let t, num_bins_is_incr = insert value t in
      h :: t, num_bins_is_incr

let rec min_diff_index i index min_diff = function
  | a :: b :: t ->
    let diff = b.center -. a.center in
    assert ( diff > 0. );
    if diff < min_diff then
      min_diff_index (i+1) i diff (b :: t)
    else
      (* no change *)
      min_diff_index (i+1) index min_diff (b :: t)

  | [ _ ] -> index
  | [] -> assert false

let min_diff_index = function
  | a :: b :: t ->
    let diff = b.center -. a.center in
    assert ( diff > 0. );
    min_diff_index 1 0 diff (b :: t)

  | [ _ ]
  | [] -> assert false

let merge_bins lo hi =
  assert (lo.center < hi.center);
  let sum_count = lo.count + hi.count in
  let center =
    (* average of centers, weighted by their height *)
    (lo.center *. (float lo.count) +. hi.center *. (float hi.count)) /.
    (float sum_count)
  in
  { center; count = sum_count }

(* not tail rec! *)
let merge_bins_at_index =
  let rec loop i index = function
    | a :: b :: t ->
      if i = index then
        let bin = merge_bins a b in
        bin :: t