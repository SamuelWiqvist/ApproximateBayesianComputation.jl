
<a id='ABC-Markov-chain-Monte-Carlo-1'></a>

# ABC Markov chain Monte Carlo


ABC-MCMC object.

<a id='ApproximateBayesianComputation.ABCMCMC' href='#ApproximateBayesianComputation.ABCMCMC'>#</a>
**`ApproximateBayesianComputation.ABCMCMC`** &mdash; *Type*.



Type for defining a problem for the ABC-MCMC algorithm

Parameters:

  * `N::Integer` nbr of iterations
  * `burn_in::Integer` length for burn-in
  * `ϵ_seq::Vector` sequence of threshold values
  * `dim_unknown::Integer` nbr of unknown parameters
  * `θ_start::Vector` start value for chain
  * `transformation::String` transformation for proposal distribution: none/log/
  * `data::Data` data
  * `adaptive_update::AdaptationAlgorithm` adaptive updating algorithm for the proposal distribtuion
  * `algorithm_type::String` type of ABC algorithm (original or general, default value original)
  * `print_interval::Integer` print interval for stats of algorithm (default value 1000)


<a id='Adaptive-tuning-of-the-proposal-distrbution-1'></a>

## Adaptive tuning of the proposal distrbution

<a id='ApproximateBayesianComputation.FixedKernel' href='#ApproximateBayesianComputation.FixedKernel'>#</a>
**`ApproximateBayesianComputation.FixedKernel`** &mdash; *Type*.



```
FixedKernel
```

Fixed proposal distribution.

Parameters:

  * `Cov::Array{Real}` covaraince matrix

<a id='ApproximateBayesianComputation.AMUpdate' href='#ApproximateBayesianComputation.AMUpdate'>#</a>
**`ApproximateBayesianComputation.AMUpdate`** &mdash; *Type*.



```
AMUpdate
```

Adaptive tuning of the proposal distribution. Sources: *A tutorial on adaptive MCMC* [https://link.springer.com/article/10.1007/s11222-008-9110-y](https://link.springer.com/article/10.1007/s11222-008-9110-y), and *Exploring the common concepts of adaptive MCMC and Covariance Matrix Adaptation schemes* [http://drops.dagstuhl.de/opus/volltexte/2010/2813/pdf/10361.MuellerChristian.Paper.2813.pdf](http://drops.dagstuhl.de/opus/volltexte/2010/2813/pdf/10361.MuellerChristian.Paper.2813.pdf)

Parameters:

  * `C_0::Array{Real}`
  * `r_cov_m::Real`
  * `gamma_0::Real`
  * `k::Real`
  * `t_0::Integer`

