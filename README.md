# [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/SamuelWiqvist/ApproximateBayesianComputation.jl/tree/dev/master) Approximate Bayesian Computation in Julia

This repository contains some Approximate Bayesian computation algorithms.

A toy example for each algorithm is also provided in the examples.

Algorithms:
* ABC rejection sampling (ABC-RS)
* ABC Markov chain Monte Carlo (ABC-MCMC)
* ABC population Monte Carlo (ABC-PMC)

Kernels:
* Uniform
* Gaussian

Distance functions:
* (Weighted) Euclidean distance

Posterior inference checks are also provided see ```?calcquantileint``` and ```?loss```.


## Minimal working example

We will in this minimal working example using the ABC rejection sampling algorithm
to learn the mean for a Normal distribution with known standard deviation.

#### Walk-through

Load packages, and set up the model.

```julia
using ApproximateBayesianComputation
using Distributions

μ = 0 # true value for the mean we want to estimate
σ = 1 # known standard deviation
n = 100 # nbr of observations

y = rand(Normal(μ,σ),100) # generate some data

# the prior is a normal distribution with
prior = Normal(0.1 1)
```

Define the functions needed for the ABC-RS algorithm.

```julia
# function to sample from the prior
sample_from_prior() = rand(prior)

# function to generate data
generate_data(μ) = rand(Normal(μ[1],σ),n)

# the summary statistics are the mean and the standard
# deviation, i.e. the sufficent statistics for the data
calc_summary(y_star,y) = [mean(y_star); std(y_star)]

# distance function
ρ(s_star, s) = Euclidean(s_star, s, [1;1])
```

Set up the ABC-RS problem.

```julia
data = Data(y)
nbr_cores = 1
problem = ABCRS(10^6,
                0.01,
                data,
                1,
                cores = nbr_cores,
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
posterior_quantile_interval = calcquantileint(approx_posterior_samples)
```


## How to use this module

This package is not added to `METADATA`. However, to install the package you can run: `Pkg.clone("https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl")`.

To run the examples directly in your browser simply click on the binder link. However, launching the binder server might take a while (in some cases up to 20 minutes) since the environment has to be set up on the server.

## About this repository

This repository was originally created for the graduate course *Approximate Bayesian Computation* at Chalmers University of Technology.
