# type
"""
Type for defining a problem for the ABC-MCMC algorithm

Parameters:

- `N::Int` nbr of iterations
- `burn_in::Int` length for burn-in
- `ϵ_seq::Vector` sequence of threshold values
- `dim_unknown::Int` nbr of unknown parameters
- `θ_start::Vector` start value for chain
- `transformation::String` transformation for proposal distribution: none/log/
- `data::Data` data
- `adaptive_update::AdaptationAlgorithm` adaptive updating algorithm for the proposal distribtuion
- `algorithm_type::String` type of ABC algorithm (`original` or `general`, default value `original`)
- `print_interval::Int` print state of algorithm at every `print_interval`th iteration (default value 1000)
"""
type ABCMCMC <: ABCAlgorithm
  N::Int # nbr of iterations
  burn_in::Real # length for burn-in
  ϵ_seq::Vector # sequence of threshold values
  dim_unknown::Int # nbr of unknown parameters
  θ_start::Vector # start value
  transformation::String
  data::Data # data
  adaptive_update::AdaptationAlgorithm
  algorithm_type::String # type of ABC algorithm
  print_interval::Int # print interval for stats of algorithm
end

# constructor
ABCMCMC(N::Int, burn_in::Real, ϵ_seq::Vector, dim_unknown::Int, θ_start::Vector, transforamtion::String, data::Data, adaptive_update::AdaptationAlgorithm; algorithm_type::String="original", print_interval::Int=1000) = ABCMCMC(N, burn_in, ϵ_seq, dim_unknown, θ_start, transforamtion, data, adaptive_update, algorithm_type, print_interval)

# method
"""
    sample(problem::ABCMCMC,
        sample_from_prior::Function,
        evaluate_prior::Function,
        generate_data::Function,
        calc_summary::Function,
        ρ::Function;
        kernel::Function = ABC.UniformKernel)

Sample from the approximate posterior distribtuion using ABC-MCMC.

Input:
- `problem::ABCMCMC` problem
- `sample_from_prior::Function` function to sample from the prior
- `evaluate_prior::Function` evaluate the prior
- `generate_data::Function` function to generate data from the model
- `calc_summary::Function` function to calculate summary statistics
- `ρ::Function` the distance function
- `kernel::Function` the kernel function

Output:

- `chain::Matrix` the chain genrated by the ABC-MCMC algorithm

"""
function sample(problem::ABCMCMC,
                sample_from_prior::Function,
                evaluate_prior::Function,
                generate_data::Function,
                calc_summary::Function,
                ρ::Function;
                kernel::Function = ABC.UniformKernel)

  # data
  y = problem.data.y
  y_star = copy(y)
  length_data = length(y) # length of data set

  # algorithm parameters
  N_iteration = problem.N # number of iterations
  burn_in = problem.burn_in # burn in
  print_interval = problem.print_interval # print accaptance rate and covarince
                                          # function every print_interval:th iteration
  θ_start = problem.θ_start
  adaptive_update = problem.adaptive_update
  parameter_transformation = problem.transformation
  algorithm_type = problem.algorithm_type

  # ABC parameters
  s = calc_summary(y,y) # compute summary statistics for data
  s_star = similar(s)
  ϵ_seq = problem.ϵ_seq

  # pre-allocate matricies and vectors
  chain = zeros(length(θ_start),N_iteration)
  accept_vec = zeros(N_iteration)
  s_matrix = zeros(length(s_star), N_iteration)

  # parameters for adaptive update
  adaptive_update_params = set_adaptive_alg_params(adaptive_update,
                                                  length(θ_start),
                                                  chain[:,1],
                                                  N_iteration)

  # print information at start of algorithm
  @printf "Starting ABC-MCMC estimating %d parameters\n" length(θ_start)
  @printf "Adaptation algorithm: %s\n" typeof(adaptive_update)

  # first iteration
  @printf "Iteration: %d\n" 1
  @printf "Covariance:\n"
  print_covariance(adaptive_update,adaptive_update_params, 1)

  # run fist iteration
  θ_star = θ_start # we accept the start value
  chain[:,1] = θ_star
  accept_vec[1] = 1
  y_star = generate_data(chain[:,1])
  s_matrix[:,1] = calc_summary(y_star,y)

  for n = 2:N_iteration # main loop

    # print progress
    if mod(n-1,print_interval) == 0
      # print progress
      @printf "Percentage done: %.2f %% \n" 100*(n-1)/N_iteration
      # print accaptace rate
      @printf "Acceptance rate on iteration %d to %d is %.4f %% \n"
      n-print_interval n-1
      (sum(accept_vec[n-print_interval:n-1])/( n-1 - (n-print_interval) ))*100
      # print covaraince function
      @printf "Covariance:\n"
      print_covariance(problem.adaptive_update,adaptive_update_params, n)
      # print threshold
      @printf "Threshold: %.4f \n"  ϵ_seq[n]
    end

    # Gaussian random walk
    (θ_star, ) = gaussian_random_walk(adaptive_update,
                                      adaptive_update_params,
                                      chain[:,n-1],
                                      n)

    # Generate data
    y_star = generate_data(θ_star)

    # Compute summary stats
    s_star = calc_summary(y_star,y)

    # evaluate prior
    prior_log_star = evaluate_prior(θ_star)
    prior_log_old = evaluate_prior(chain[:,n-1])

    # calc jacobian for transforamtion of proposal space
    jacobian_log_star = jacobian(θ_star, parameter_transformation)
    jacobian_log_old = jacobian(chain[:,n-1], parameter_transformation)

    # compute accaptace probability
    if algorithm_type == "original"
      abc_likelihood_star = kernel(s_star, s, ϵ_seq[n], ρ)
      a_log = log(abc_likelihood_star) + prior_log_star +  jacobian_log_star
              - (prior_log_old + jacobian_log_old)
    else
      abc_likelihood_star = kernel(s_star, s, ϵ_seq[n], ρ)
      abc_likelihood_old = kernel(s_matrix[:,n-1], s, ϵ_seq[n], ρ)
      a_log = log(abc_likelihood_star) + prior_log_star +  jacobian_log_star
              - (log(abc_likelihood_old) +  prior_log_old + jacobian_log_old)
    end

    accept =  log(rand()) < a_log

    # update chain
    if accept # the proposal is accapted
      chain[:,n] = θ_star # update chain with new proposals
      accept_vec[n] = 1
      s_matrix[:,n] = s_star
    else
      s_matrix[:,n] = s_matrix[:,n-1]
      chain[:,n] = chain[:,n-1] # keep old values
    end

    # adaptation of covaraince matrix for the proposal distribution
    adaptation(adaptive_update, adaptive_update_params, chain, n,a_log)

  end

  @printf "Ending ABC-MCMC\n"

  # return chian
  return  chain

end


# help functions for ABc-MCMC

doc"""
    jacobian(θ::Vector, parameter_transformation::String)

Returnes log-Jacobian for transformation of parameter space.
"""
function jacobian(θ::Vector, parameter_transformation::String)

  if parameter_transformation == "none"
    return 0.
  elseif parameter_transformation == "log"
    return sum(θ)
  end

end
