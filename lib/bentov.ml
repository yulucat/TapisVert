
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