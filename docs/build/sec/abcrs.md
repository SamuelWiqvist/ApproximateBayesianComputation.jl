
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


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/f39fb4d489dbf9adefa5fe467339f80e3aa7837c/src\abcrs.jl#L2-L14' class='documenter-source'>source</a><br>

