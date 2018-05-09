# Simple example

Let us use the  ABC rejection sampling algorithm to learn the mean for a Normal distribution
with known standard deviation, where the prior for the unknown mean is a Normal distibution.

Load packages.

```julia
julia> using ApproximateBayesianComputation
julia> using Distributions
```

Set parameters for data model.

```julia
julia> μ = 0 # true value for the mean, the parameter that  we want to estimate
julia> σ = 1 # known standard deviation
julia> n = 100 # nbr of observations
```
Generate some data

```julia
julia> y = rand(Normal(μ,σ),100) # generate some data
```

Set prior distibution. The prior is a normal distribution with μ = 0.1, and σ = 1

```julia
julia> prior = Normal(0.1, 1)
```

Define the functions needed for the ABC-RS algorithm.

```julia
julia> sample_from_prior() = rand(prior) # function to sample from the prior
julia> generate_data(μ) = rand(Normal(μ[1],σ),n) # function to generate data
julia> calc_summary(y_star,y) = [mean(y_star); std(y_star)]  # the summary statistics
julia> ρ(s_star, s) = euclidean_dist(s_star, s, ones(2)) # distance function
```

Set up the ABC-RS problem.

```julia
julia> problem = ABCRS(10^6, 0.01, Data(y), 1, cores = 1, print_interval = 10^5)
```

Run ABC-RS.

```julia
julia> approx_posterior_samples = sample(problem,
                                         sample_from_prior,
                                         generate_data,
                                         calc_summary,
                                         ρ)
```

Check posterior quantile interval.

```julia
julia> posterior_quantile_interval = quantile_interval(approx_posterior_samples)
```
