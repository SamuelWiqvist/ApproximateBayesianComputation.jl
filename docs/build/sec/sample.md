
<a id='Sample-1'></a>

# Sample

<a id='StatsBase.sample' href='#StatsBase.sample'>#</a>
**`StatsBase.sample`** &mdash; *Function*.



```
sample(problem::ABCRS,
       sample_from_prior::Function,
       generate_data::Function,
       calc_summary::Function,
       ρ::Function)
```

Sample from the approximate posterior distribtuion using ABC rejection sampling.

Input:

  * `problem::ABCRS` problem
  * `sample_from_prior::Function` function to sample from the prior
  * `generate_data::Function` function to generate data from the model
  * `calc_summary::Function` function to calculate summary statistics
  * `ρ::Function` the distance function

Output:

  * `samples_approx_posterior::Matrix` samples from the approxiamte posterior


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/f39fb4d489dbf9adefa5fe467339f80e3aa7837c/src\abcrs.jl#L30-L48' class='documenter-source'>source</a><br>


```
sample(problem::ABCPMC,
       sample_from_prior::Function,
       evaluate_prior::Function,
       generate_data::Function,
       calc_summary::Function,
       ρ::Function)
```

Sample from the approximate posterior distribtuion using PMC-ABC algorithm described in *Adaptive approximate Bayesian computation* [http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.313.3573&rep=rep1&type=pdf](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.313.3573&rep=rep1&type=pdf).

Input:

  * `problem::ABCPMC` problem
  * `sample_from_prior::Function` function to sample from the prior
  * `generate_data::Function` function to generate data from the model
  * `calc_summary::Function` function to calculate summary statistics
  * `ρ::Function` the distance function

Output:

  * `θ_pop::Matrix` last population


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/f39fb4d489dbf9adefa5fe467339f80e3aa7837c/src\abcpmc.jl#L29-L49' class='documenter-source'>source</a><br>


```
sample(problem::ABCMCMC,
       sample_from_prior::Function,
       evaluate_prior::Function,
       generate_data::Function,
       calc_summary::Function,
       ρ::Function;
       kernel::Function = uniform_kernel)
```

Sample from the approximate posterior distribtuion using ABC-MCMC.

Input:

  * `problem::ABCMCMC` problem
  * `sample_from_prior::Function` function to sample from the prior
  * `evaluate_prior::Function` evaluate the prior
  * `generate_data::Function` function to generate data
  * `calc_summary::Function` function to calculate summary statistics
  * `ρ::Function` the distance function
  * `kernel::Function` the kernel function

Output:

  * `chain::Matrix` the chain genrated by the ABC-MCMC algorithm


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/f39fb4d489dbf9adefa5fe467339f80e3aa7837c/src\abcmcmc.jl#L33-L55' class='documenter-source'>source</a><br>

