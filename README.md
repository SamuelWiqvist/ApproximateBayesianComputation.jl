# [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/SamuelWiqvist/ApproximateBayesianComputation.jl/master) Approximate Bayesian Computation in Julia

![![Build Status](https://travis-ci.org/SamuelWiqvist/ApproximateBayesianComputation.jl.svg?branch=master)](https://travis-ci.org/SamuelWiqvist/ApproximateBayesianComputation.jl) [![Build status](https://ci.appveyor.com/api/projects/status/6iukm6um8355uldi?svg=true)](https://ci.appveyor.com/project/SamuelWiqvist/approximatebayesiancomputation-jl)[![Coverage Status](https://coveralls.io/repos/github/SamuelWiqvist/ApproximateBayesianComputation.jl/badge.svg)](https://coveralls.io/github/SamuelWiqvist/ApproximateBayesianComputation.jl)[![codecov](https://codecov.io/gh/SamuelWiqvist/ApproximateBayesianComputation.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/SamuelWiqvist/ApproximateBayesianComputation.jl)

This repository contains some Approximate Bayesian computation algorithms.

A toy example for each algorithm is also provided in the examples.

Algorithms:
* ABC rejection sampling (ABC-RS)
* ABC Markov chain Monte Carlo (ABC-MCMC)
* ABC population Monte Carlo (ABC-PMC)

Kernels:
* Uniform
* Gaussian

Distance function(s):
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
posterior_quantile_interval = calcquantileint(approx_posterior_samples)
```

Posterior and prior distribution.

![](/assets/post_min_example.png)


## How to use this package

This package is not added to `METADATA.jl`. But, you can still install the package locally by running:

```julia
Pkg.clone("https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl")
 ```

To run the examples directly in your browser simply click on the binder link, and then open the Jupyter notebook `examples.ipynb`. However, launching the binder server might take a while (in some cases up to 20 minutes) since the environment has to be installed on the server.

## About this package

This package was originally created for the graduate course *Approximate Bayesian Computation* at Chalmers University of Technology.
