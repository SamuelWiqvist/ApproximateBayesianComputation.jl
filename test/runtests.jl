addprocs(4)

@everywhere using ApproximateBayesianComputation
using Base.Test

# test help functions
include("test_distancefunctions.jl")
include("test_kernels.jl")
include("test_posteriorinference.jl")
include("test_utilities.jl")

# include model that we test the algorithms on
include("gaussian_gaussian_models.jl")

# run tests for algorithms
include("test_abcrs.jl")
include("test_abcmcmc.jl")
include("test_abcpmc.jl")
