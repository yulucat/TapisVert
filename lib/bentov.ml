
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
      else
        a :: (loop (i + 1) index (b :: t))

    | [ _ ]
    | [] -> assert false
  in
  fun index bins ->
    loop 0 index bins

let create max_bins =
  if max_bins < 2 then
    raise (Invalid_argument (Printf.sprintf "max_bins: %d" max_bins))
  else {
    max_bins;
    num_bins = 0;
    bins = [];
    total_count = 0;
    range = None
  }

let add value histogram =
  let range =
    match histogram.range with
      | Some (mn, mx) -> Some (min value mn, max value mx)
      | None -> Some (value, value)
  in
  let total_count = histogram.total_count + 1 in
  let bins, is_augmented = insert value histogram.bins in
  if histogram.num_bins = histogram.max_bins then
    if is_augmented then
      (* merge bins, so as to keep their number at [max_bins] *)
      let index = min_diff_index bins in
      let bins = merge_bins_at_index index bins in
      { histogram with bins; range; total_count }
    else
      { histogram with bins; range; total_count }
  else
    if is_augmented then
      { histogram with bins; range; total_count;
                       num_bins = histogram.num_bins + 1; }
    else
      { histogram with bins; range; total_count }

(* merge two sorted bin lists; not tail rec! *)
let rec binary_merge a b =
  match a, b with
    | a_h :: a_t, b_h :: b_t ->
      if a_h.center < b_h.center then
        a_h :: (binary_merge a_t b)
      else if a_h.center > b_h.center then
        b_h :: (binary_merge a b_t)
      else
        (* a_h.center = b_h.center: merge the two cells into one *)
        let merged = { a_h with count = a_h.count + b_h.count } in
        merged :: (binary_merge a_t b_t)

    | [], _ :: _ -> b
    | _ :: _, [] -> a
    | [], [] -> []

let rec k_ary_merge_half accu = function
  | a :: b :: t ->
    let ab = binary_merge a b in
    k_ary_merge_half  (ab :: accu) t

  | [a] -> (a :: accu)