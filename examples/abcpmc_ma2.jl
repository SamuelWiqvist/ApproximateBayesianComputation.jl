
addprocs(2)

@everywhere using ApproximateBayesianComputation
@everywhere using Distributions
@everywhere using StatsBase
using KernelDensity
using PyPlot

@everywhere N_data = 100 # nbr of observations

# prior distribtuion

# The prior distribtuion: the parameters are defined on the triangle where
# -2 < θ_1 < 2, and  θ_1+θ_2 > 1, θ_1 - θ_2 < 1

# Sample from the Uniform prior distribution
@everywhere function sample_from_prior()

  while true
    θ_1 = rand(Uniform(-2,2))
    θ_2 = rand(Uniform(-1,1))
    if θ_2 + θ_1  >= -1 && θ_2 - θ_1 >= -1
      return [θ_1; θ_2]
    end
  end

end

# Evaluate prior distribtuion
@everywhere function evaluate_prior(Θ::Vector)
  θ_1 = Θ[1]
  θ_2 = Θ[2]
  if abs(θ_1) <= 2 && abs(θ_2) <= 1 &&  θ_2 + θ_1  >= -1 && θ_2 - θ_1 >= -1
    return 1.
  else
    return 0.
  end
end

# Generate data from the model
@everywhere function generate_data(Θ::Vector)

  θ_1 = Θ[1]
  θ_2 = Θ[2]

  if abs(θ_1) <= 2 && abs(θ_2) <= 1 &&   θ_2 + θ_1  >= -1 && θ_2 - θ_1 >= -1

    y = zeros(N_data)
    ϵ = randn(N_data)

    y[1] = ϵ[1]
    y[2] = ϵ[2] - θ_1*y[1]

    @inbounds for i = 3:N_data
      y[i] = ϵ[i] + θ_1*ϵ[i-1] + θ_2*ϵ[i-2]
    end

    return y
  else
    return NaN*ones(N_data)
  end

end

# Computes the summary statistics"
@everywhere calc_summary(y_sim::Vector, y_obs::Vector) = autocor(y_sim, 1:2)

# distance function
@everywhere ρ(s::Vector, s_star::Vector) = Euclidean(s, s_star, ones(2))


# generate data set
θ_true = [0.6; 0.2]
y = generate_data(θ_true)
data = Data(y)

PyPlot.figure()
PyPlot.plot(y)
PyPlot.xlabel("t")


# set start value for ϵ_seq
s = calc_summary(y,y)

ρ_vec = zeros(500)

for i = 1:500
  ρ_vec[i] = ρ(s, calc_summary(generate_data(sample_from_prior()),y))
end

summarystats(ρ_vec)

# plot ´hist of distances when we sample proposals from the prior
PyPlot.figure()
PyPlot.plt[:hist](ρ_vec,50)
PyPlot.ylabel("Freq.")
PyPlot.xlabel(L"$\rho$")

# create ABC-MCMC problem

ϵ_seq = [2; 1.5; 1; 0.5; 0.1; 0.01]
T = length(ϵ_seq)
N = 500
dim_unknown = 2
nbr_cores = length(workers())
problem = PMCABC(T,N,ϵ_seq,data,dim_unknown,cores = nbr_cores)

# run ABC-MCMC
approx_posterior_samples = @time sample(problem,
                                        sample_from_prior,
                                        evaluate_prior,
                                        generate_data,
                                        calc_summary,
                                        ρ)

# calc posterior quantile interval
posterior_quantile_interval = calcquantileint(approx_posterior_samples)

PyPlot.figure()
PyPlot.plot((0,-2),(-1,1), "g")
PyPlot.plot((-2,2),(1,1), "g")
PyPlot.plot((0,2),(-1,1), "g")
PyPlot.scatter(approx_posterior_samples[1,:],approx_posterior_samples[2,:])
PyPlot.plot(θ_true[1],θ_true[2], "k*")
PyPlot.xlabel(L"$\theta_1$")
PyPlot.ylabel(L"$\theta_2$")
