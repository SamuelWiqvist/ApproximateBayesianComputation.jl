
<a id='ABC-rejections-sampling-1'></a>

# ABC rejections sampling


ABC-RS object.

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

