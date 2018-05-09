
<a id='Sample-1'></a>

# Sample


`sample` is a multimethod function with one implementation for each algorithm.


Sample method for `ABCRS`.

<a id='StatsBase.sample-Tuple{ApproximateBayesianComputation.ABCRS,Function,Function,Function,Function}' href='#StatsBase.sample-Tuple{ApproximateBayesianComputation.ABCRS,Function,Function,Function,Function}'>#</a>
**`StatsBase.sample`** &mdash; *Method*.



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


Sample method for `ABCMCMC`.

<a id='StatsBase.sample-Tuple{ApproximateBayesianComputation.ABCMCMC,Function,Function,Function,Function,Function}' href='#StatsBase.sample-Tuple{ApproximateBayesianComputation.ABCMCMC,Function,Function,Function,Function,Function}'>#</a>
**`StatsBase.sample`** &mdash; *Method*.



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


Sample method for `ABCPMC`.

<a id='StatsBase.sample-Tuple{ApproximateBayesianComputation.ABCPMC,Function,Function,Function,Function,Function}' href='#StatsBase.sample-Tuple{ApproximateBayesianComputation.ABCPMC,Function,Function,Function,Function,Function}'>#</a>
**`StatsBase.sample`** &mdash; *Method*.



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

