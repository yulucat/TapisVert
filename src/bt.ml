
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
    x
  else
    fold_lines f ch x


let histogram_of_file path_opt max_bins =
  let ch =
    match path_opt with
      | Some path -> open_in path
      | None -> stdin
  in

  let hist = fold_lines (
    fun hist line ->
      let value = float_of_string line in
      add value hist
  ) ch (create max_bins) in

  close_in ch;

  hist

let print_uniform hist num_intervals =
  let u = uniform hist num_intervals in
  pr "uniform with %d intervals:\n%!" num_intervals;
  List.iter (
    fun  (rank, quantile) ->
      pr "%d/%d[=%.3f] %+.5e\n" rank num_intervals
        ((float rank)/.(float num_intervals)) quantile
  ) u


let print_mean_stdev hist =
  let m, sd = mean_stdev hist in
  pr "mean=%+.5e\nstdev=%+.5e\n" m sd


let main max_bins path_opt p_histogram p_mean_stdev p_uniform =
  let hist = histogram_of_file path_opt max_bins in
  if p_mean_stdev then (
    print_mean_stdev hist;
    pr "\n"
  );

  if p_histogram then (
    print_histogram hist;
    pr "\n"
  );