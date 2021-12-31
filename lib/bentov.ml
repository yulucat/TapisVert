
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