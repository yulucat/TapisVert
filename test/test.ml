
(* In this test, we measure the error between the true quantiles of
   data, and the quantiles as computed through the [Bentov] histogram
   approximation module. The data is drawn from a mixture of two
   Gaussians, N(2,1) and N(5,1), where the mixing coefficient is 1/2.
   We compute the approximate quantiles in two ways: In the frist, we
   simply add each sample into a [Bentov.histogram]. We call this
   histogram [mixed]. In the second, we add a datum to one of two
   [Bentov.histogram]'s, one associated with each of the Guassians. We
   then merge these two histograms using [Bentov.merge]. We call the
   result of merging the two sub-histograms [merged]. Finally, we
   compute and print the mean-square-error between the true quantiles