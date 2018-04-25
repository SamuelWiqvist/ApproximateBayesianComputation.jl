
addprocs(2)

@everywhere using ApproximateBayesianComputation
@everywhere using Distributions
using KernelDensity
using PyPlot

# data model
@everywhere m = 4
@everywhere n = 5
p = 0.7

y = rand(Binomial(m,p),n) # generate data

# prior distribution
@everywhere α = 2
@everywhere β = 2

@everywhere prior = Beta(α, β)

# posterior, the posterior is analutically known for the beta-binomial model
posterior = Beta(α + sum(y), β + m*n - sum(y))

# set up ACB rejectin sampling problem

# function to sample from prior distribution
@everywhere sample_from_prior() = rand(prior)

# funciton to generate data from the model
@everywhere generate_data(p) = rand(Binomial(m,p),n)

# the summery statistics are just the generated data set, hence
# no summary statistics are used
@everywhere calc_summary(y_star,y) = y_star


# compute absolute distance between the data sets
@everywhere ρ(s_star, s) = sum(abs.(sort(s_star)-sort(s)))


# create ABC rejection sampling problem
data = Data(y)

nbr_cores = length(workers())

problem = ABCRS(10^6, 0, data, 1, cores = nbr_cores, print_interval = 10000)

approx_posterior_samples = @time sample(problem,
                                            sample_from_prior,
                                            generate_data,
                                            calc_summary,
                                            ρ)

# calc posterior quantile interval
posterior_quantile_interval = calcquantileint(approx_posterior_samples, true)

# calc kernel density est. for approxiamte posterior
kde_approx_posterior = kde(approx_posterior_samples[:])

# plot results
PyPlot.figure()
PyPlot.plot(kde_approx_posterior.x,kde_approx_posterior.density, "b")
PyPlot.plot(0:0.01:1,pdf(posterior, 0:0.01:1), "r")
PyPlot.plot(0:0.01:1, pdf(prior, 0:0.01:1), "g")
PyPlot.plot((p, p), (0, maximum(kde_approx_posterior.density)), "k")
PyPlot.xlabel("p")
PyPlot.ylabel("Density")
PyPlot.legend(["ABC posterior"; "Analytical posterior"; "Prior"; "True value"])
