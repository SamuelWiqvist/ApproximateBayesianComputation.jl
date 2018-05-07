
<a id='ABC-Markov-chain-Monte-Carlo-1'></a>

# ABC Markov chain Monte Carlo


ABC-MCMC object.

<a id='ApproximateBayesianComputation.ABCRS' href='#ApproximateBayesianComputation.ABCRS'>#</a>
**`ApproximateBayesianComputation.ABCRS`** &mdash; *Type*.



Type for defining a problem for the ABC rejection sampling algorithm

Parameters:

  * `N::Integer` nbr of iterations
  * `ϵ::Real` threshold
  * `data::Data` data
  * `dim_unknown::Integer` nbr of unknown parameters
  * `cores::Integer` nbr of course (default value 1)
  * `print_interval::Integer` print state of algorithm at every `print_interval`th iteration (default value 1000)


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/d17b73be7f901fee96be0095d13ea4d32bf9fce1/src\abcrs.jl#L2-L14' class='documenter-source'>source</a><br>

