
open Bentov

let pr = Printf.printf

let print_histogram h =
  let count = total_count h in
  pr "total_count=%d\n" count;
  pr "max_bins=%d\n" (max_bins h);
  pr "num_bins=%d\n" (num_bins h);
  (match (range h) with
    | Some (mn, mx) -> pr "min=%+.5e\nmax=%+.5e\n" mn mx
    | None -> ()
  );
  let count_f = float count in
  List.iter (
    fun bin ->
      let frequency = (float bin.count) /. count_f in
      pr "%.8f %8d %.3e\n"  bin.center bin.count frequency
  ) (bins h);
  pr "\n"

let rec fold_lines f ch x0 =
  let x, is_done =
    try
      let line = input_line ch in
      let x = f x0 line in
      x, false
    with End_of_file ->
      x0, true
  in
  if is_done then