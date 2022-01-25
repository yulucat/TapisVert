type bin = {
  center : float;
  (** the center of the bin *)

  count : int;
  (** the number of values in the bin *)
}
(** [bin] represents one of the bins in a 1D histogram. The bin is
    centered in [center] and its mass is [count], half of which is on
    either side of [center]. *)

type histogra