# Simple example

Let us use the  ABC rejection sampling algorithm to learn the mean for a Normal distribution
with known standard deviation, where the prior for unknown mean is a Normal distibution.

Load packages, and set up the model.

```julia
using ApproximateBayesianComputation
using Distributions

μ = 0 # true value for the mean, the parameter that  we want to estimate
σ = 1 # known standard deviation
n = 100 # nbr of observations

y = rand(Normal(μ,σ),100) # generate some data

# the prior is a normal distribution with μ = 0.1, and σ = 1
prior = Normal(0.1, 1)
```

Define the functions needed for the ABC-RS algorithm.

```julia
# function to sample from the prior
sample_from_prior() = rand(prior)

# function to generate data
generate_data(μ) = rand(Normal(μ[1],σ),n)

# the summary statistics are the mean and the standard
# deviation, i.e. the sufficient statistics for the data
calc_summary(y_star,y) = [mean(y_star); std(y_star)]

# distance function
ρ(s_star, s) = euclidean_dist(s_star, s, ones(2))
```

Set up the ABC-RS problem.

```julia
problem = ABCRS(10^6,
                0.01,
                Data(y),
                1,
                cores = 1,
                print_interval = 10^5)
```

Run ABC-RS.

```julia
approx_posterior_samples = sample(problem,
                                  sample_from_prior,
                                  generate_data,
                                  calc_summary,
                                  ρ)
```

Check posterior quantile interval.

```julia
posterior_quantile_interval = quantile_interval(approx_posterior_samples)
```
