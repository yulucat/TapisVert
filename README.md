
# Bentov

An OCaml implementation of histogram-sketching algorithm described in
[A Streaming Parallel Decision Tree
Algorithm](http://jmlr.org/papers/volume11/ben-haim10a/ben-haim10a.pdf)
by Yael Ben-Haim and Elad Tom-Tov. Included is a command-line utility
`bt`, which can read a file (or stdin) containing numbers, one per
line, and output a representation of the approximated distribution.