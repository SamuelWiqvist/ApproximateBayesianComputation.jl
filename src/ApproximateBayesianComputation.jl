__precompile__(true)

module ApproximateBayesianComputation

# load packages
using StatsBase, Distributions

# import sample
import Distributions.sample
import StatsBase.sample

# export functions and types
export
  # types
  ABCRS,
  ABCMCMC,
  ABCPMC,
  Data,

  # methods
  sample, # algorithms
  Euclidean, # distance functions
  GaussianKernelDistance, 
  UniformKernel, # kernels
  GaussianKernel,
  calcquantileint, # posterior inference
  loss,
  log_unifpdf, # log pdfs

  AMUpdate, # adaptive updating algorithms for ABC-MCMC
  noAdaptation


# load adaptive update parameters
include("adaptive updating algorithms/adaptiveupdate.jl")


# load soruce files for ABC algorithms and related methods
include("types.jl")  # types
include("abcrs.jl") # algorithms
include("abcpmc.jl")
include("abcmcmc.jl")
include("distancefunctions.jl") # distance functions
include("kernels.jl") # kernels
include("posteriorinference.jl") # posterior inference functions
include("utilities.jl") # log pdfs and other useful functions



"""
Approximate Bayesian computation algorithms.

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
ρ(s_star, s) = Euclidean(s_star, s, ones(2))
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


"""
ApproximateBayesianComputation

end
