type bin = {
  center : float;
  (** the center of the bin *)

  count : int;
  (** the number of values in the bin *)
}
(** [bin] represents one of the bins in a 1D histogram. The bin is
    centered in [center] and its mass is [count], half of which is on
    either side of [center]. *)

type histogram

val bins : histogram -> bin list
(** [bins h] returns the list of bins, sorted by the bin center,
    comprising histogram [h] *)

val num_bins : histogram -> int
(** [num_bins h] returns the size of the histogram [h] in terms of the
    number of bins; equivalent to [List.length (bins h)] *)

val max_bins : histogram -> int
(** [max_bins h] returns the maximum number of bins of this histogram;
    when the number of unique values added to the histogram exceeds
    this [max_bins h], [h] becomes an approximation. *)

val total_count : histogram -> int
(** [total_count h] returns th