
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