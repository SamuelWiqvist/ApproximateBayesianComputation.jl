
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


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/e462f22d3194c7bcc5dec24708fc4385d8ca1ab8/src\abcpmc.jl#L2-L14' class='documenter-source'>source</a><br>

