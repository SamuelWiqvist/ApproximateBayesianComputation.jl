
<a id='ABC-population-Monte-Carlo-1'></a>

# ABC population Monte Carlo


ABC-PMC object.

<a id='ApproximateBayesianComputation.ABCPMC' href='#ApproximateBayesianComputation.ABCPMC'>#</a>
**`ApproximateBayesianComputation.ABCPMC`** &mdash; *Type*.



Type for defining a problem for the ABC rejection sampling algorithm

Parameters:

  * `T::Integer` nbr of iterations
  * `N::Integer` nbr of samples in the population
  * `ϵ::Real` start threshold
  * `data::Data` data
  * `dim_unknown::Integer` nbr of unknown parameters
  * `cores::Integer` nbr of course (default value 1)
  * `print_interval::Integer` print state of algorithm at every `print_interval`th iteration (default value 1000)


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/f39fb4d489dbf9adefa5fe467339f80e3aa7837c/src\abcpmc.jl#L2-L14' class='documenter-source'>source</a><br>

