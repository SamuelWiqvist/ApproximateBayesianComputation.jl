addprocs(4)

@everywhere using ApproximateBayesianComputation
using Base.Test

include("test_distancefunctions.jl")
include("test_kernels.jl")
include("test_posteriorinference.jl")

include("test_abcrs.jl")
include("test_abcmcmc.jl")


#=
include("test_abcpmc.jl")
=#
