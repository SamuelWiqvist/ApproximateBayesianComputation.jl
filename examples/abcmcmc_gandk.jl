using ApproximateBayesianComputation
using Distributions
using KernelDensity
using PyPlot
using StatsBase

N_data = 5*10^3 # nbr of observations
c = 0.8 # fixed parameter

# prior distribtuion

# The prior distribtuion for all parmameters is a Uniform(0,10) distribution

# Sample from the Uniform prior distribution
sample_from_prior() = rand(Uniform(0, 10),4)


# Evaluate the prior dist on log-scale
function  evaluate_prior(Θ::Vector)

  # set start value for loglik
  log_prior = 0.
  for i = 1:length(Θ)
    log_prior += ApproximateBayesianComputation.log_unifpdf( Θ[i], 0, 10 )
  end

  return log_prior # return log_lik

end

# Generate data from the model
function generate_data(Θ::Vector)

  A = Θ[1]
  B = Θ[2]
  g = Θ[3]
  k = Θ[4]

  z = rand(Normal(0,1), N_data)

  F_inv = similar(z)

  @inbounds for i = 1:length(F_inv)
    F_inv[i] = A + B*(1 + c*(1-exp(-g*z[i]))/(1+exp(-g*z[i])))*(1+z[i]^2)^k*z[i]
  end

  return F_inv

end

# Computes the summary statistics
calc_summary(y_sim::Vector, y_obs::Vector) = [percentile(y_sim, [20;40;60;80]);skewness(y_sim)]

# create distance function
w  =  [0.22; 0.19; 0.53; 2.97; 1.90]  # from " Approximate maximum likelihood estimation using data-cloning ABC"
ρ(s::Vector, s_star::Vector) = Euclidean(s::Vector, s_star::Vector, w)


# generate data set
θ_true = [3; 1; 2; .5]
y = generate_data(θ_true)
data = ApproximateBayesianComputation.Data(y)

# create ABC-MCMC problem
ϵ_seq = [30*ones(1000);20*ones(1000);10*ones(1000); 5*ones(1000); 2.5*ones(1000); 1*ones(1000); 0.5*ones(1000); 0.3*ones(100000)] # ; 0.05*ones(100000)
burn_in = length(ϵ_seq)-100000
N = length(ϵ_seq)
dim_unknown = 4
#θ_start = sample_from_prior()
θ_start =  [5;5;3; 2] # fixed start values far away from the true parameter values
adaptive_update = ApproximateBayesianComputation.AMUpdate(eye(dim_unknown), 2.4/sqrt(dim_unknown), 1., 0.7, 25) # use the AM algorithm to tune the proposal distribution
problem = ApproximateBayesianComputation.ABCMCMC(N, burn_in, ϵ_seq, dim_unknown, θ_start, "none", data, adaptive_update)

# run ABC-MCMC
chain = @time ApproximateBayesianComputation.sample(problem,
                        sample_from_prior,
                        evaluate_prior,
                        generate_data,
                        calc_summary,
                        ρ)


# calc posterior quantile interval
posterior_quantile_interval = ApproximateBayesianComputation.calcquantileint(chain[:,burn_in+1:end])


# plot chains
PyPlot.figure()
PyPlot.subplot(411)
PyPlot.plot(chain[1,:])
PyPlot.plot(ones(size(chain,2),1)*θ_true[1], "k")
PyPlot.ylabel(L"$A$")
PyPlot.subplot(412)
PyPlot.plot(chain[2,:])
PyPlot.plot(ones(size(chain,2),1)*θ_true[2], "k")
PyPlot.ylabel(L"$B$")
PyPlot.subplot(413)
PyPlot.plot(chain[3,:])
PyPlot.plot(ones(size(chain,2),1)*θ_true[3], "k")
PyPlot.ylabel(L"$g$")
PyPlot.subplot(414)
PyPlot.plot(chain[4,:])
PyPlot.plot(ones(size(chain,2),1)*θ_true[4], "k")
PyPlot.xlabel(L"Iteration")
PyPlot.ylabel(L"$k$")


# plot chains after burn in
PyPlot.figure()
PyPlot.subplot(411)
PyPlot.plot(chain[1,burn_in:end])
PyPlot.plot(ones(size(chain[:,burn_in:end],2),1)*θ_true[1], "k")
PyPlot.ylabel(L"$A$")
PyPlot.subplot(412)
PyPlot.plot(chain[2,burn_in:end])
PyPlot.plot(ones(size(chain[:,burn_in:end],2),1)*θ_true[2], "k")
PyPlot.ylabel(L"$B$")
PyPlot.subplot(413)
PyPlot.plot(chain[3,burn_in:end])
PyPlot.plot(ones(size(chain[:,burn_in:end],2),1)*θ_true[3], "k")
PyPlot.ylabel(L"$g$")
PyPlot.subplot(414)
PyPlot.plot(chain[4,burn_in:end])
PyPlot.plot(ones(size(chain[:,burn_in:end],2),1)*θ_true[4], "k")
PyPlot.xlabel(L"Iteration")
PyPlot.ylabel(L"$k$")


# plot marginal posterior distributions

# calc grid for prior dist
x_grid = -0.5:0.01:10.5

# calc prior dist
priordensity = pdf(Uniform(0, 10), x_grid)


h1 = kde(chain[1,burn_in:end])
h2 = kde(chain[2,burn_in:end])
h3 = kde(chain[3,burn_in:end])
h4 = kde(chain[4,burn_in:end])

PyPlot.figure()
subplot(221)
PyPlot.plot(h1.x,h1.density, "b")
PyPlot.plot(x_grid,priordensity, "g")
PyPlot.plot((θ_true[1], θ_true[1]), (0, maximum(h1.density)), "k")
PyPlot.ylabel(L"Density")
PyPlot.xlabel(L"$A$")
subplot(222)
PyPlot.plot(h2.x,h2.density, "b")
PyPlot.plot(x_grid,priordensity, "g")
PyPlot.plot((θ_true[2], θ_true[2]), (0, maximum(h2.density)), "k")
PyPlot.xlabel(L"$B$")
subplot(223)
PyPlot.plot(h3.x,h3.density, "b")
PyPlot.plot(x_grid,priordensity, "g")
PyPlot.plot((θ_true[3], θ_true[3]), (0, maximum(h3.density)), "k")
PyPlot.xlabel(L"$g$")
PyPlot.ylabel(L"Density")
subplot(224)
PyPlot.plot(h4.x,h4.density, "b")
PyPlot.plot(x_grid,priordensity, "g")
PyPlot.plot((θ_true[4], θ_true[4]), (0, maximum(h4.density)), "k")
PyPlot.xlabel(L"$k$")
