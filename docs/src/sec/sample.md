# Sample

`sample` is a multimethod function with one implementation for each algorithm.

Sample method for `ABCRS`.

```@docs
ApproximateBayesianComputation.sample(problem::ApproximateBayesianComputation.ABCRS, sample_from_prior::Function, generate_data::Function, calc_summary::Function, ρ::Function)
```

Sample method for `ABCMCMC`.


```@docs
ApproximateBayesianComputation.sample(problem::ApproximateBayesianComputation.ABCMCMC, sample_from_prior::Function, evaluate_prior::Function, generate_data::Function, calc_summary::Function, ρ::Function)
```
Sample method for `ABCPMC`.

```@docs
ApproximateBayesianComputation.sample(problem::ApproximateBayesianComputation.ABCPMC, sample_from_prior::Function, evaluate_prior::Function, generate_data::Function, calc_summary::Function, ρ::Function)
```
