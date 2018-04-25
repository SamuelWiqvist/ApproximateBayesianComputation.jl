module ApproximateBayesianComputation

# load packages
using StatsBase
using Distributions

# load adaptive update parameters
include("adaptive updating algorithms/adaptiveupdate.jl")


# load soruce files for ABC algorithms and related methods
include("types.jl")  # types
include("abcrs.jl") # algorithms
include("pmcabc.jl")
include("abcmcmc.jl")
include("distancefunctions.jl") # distance functions
include("kernels.jl") # kernels
include("posteriorinference.jl") # posterior inference functions
include("utilities.jl") # log pdfs and other useful functions

# export functions and types
export

  # types
  ABCRS
  ABCMCMC
  PMCABC
  ABCSMC

  # methods
  sample # algorithms
  Euclidian # distance functions
  UniformKernel # kernels
  calcquantileint # posterior inference
  RMSE
  log_unifpdf # log pdfs

  AMUpdate # adaptive updating algorithms for ABC-MCMC
  noAdaptation


"""
Approximate Bayesian computation algorithms.

Algorithms:
* ABC-RS
* ABC-PMC
* ABC-MCMC

Kernels:
* Uniform
* Gaussian

Distance functions:
* (Wigthed) Euclidian distnace

Posterior inference checks are also provided see `?calcquantileint` and `?RMSE`.
"""
ABC

end
