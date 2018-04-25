# type
"""
Type for defining a problem for the ABC rejection sampling algorithm

Parameters:

- `N::Int` nbr of iterations
- `ϵ::Real` threshold
- `data::Data` data
- `dim_unknown::Int` nbr of unknown parameters
- `cores::Int` nbr of course (default value 1)
- `print_interval::Int` print state of algorithm at every
  `print_interval`th iteration (default value 1000)
"""
type ABCRS <: ABCAlgorithm
  N::Int # nbr of iterations
  ϵ::Real # threshold
  data::Data # data
  dim_unknown::Int # nbr of unknown parameters
  cores::Int # nbr of course
  print_interval::Int # print interval for stats of algorithm
end

# constructor
ABCRS(N::Int, ϵ::Real, data::Data, dim_unknown::Int;
      cores::Int=1, print_interval::Int=1000) = ABCRS(N, ϵ, data, dim_unknown,
                                                      cores, print_interval)

# method
"""
    sample(problem::ABCRS,
      sample_from_prior::Function,
      generate_data::Function,
      calc_summary::Function,
      ρ::Function,
      kernel::Function)

Sample from the approximate posterior distribtuion using ABC rejection sampling.

Input:
- `problem::ABCRS` problem
- `sample_from_prior::Function` function to sample from the prior
- `generate_data::Function` function to generate data from the model
- `calc_summary::Function` function to calculate summary statistics
- `ρ::Function` the distance function
- `kernel::Function` the kernel function

Output:

- `samples_approx_posterior::Matrix` samples from the approxiamte posterior

"""
function sample(problem::ABCRS,
                sample_from_prior::Function,
                generate_data::Function,
                calc_summary::Function,
                ρ::Function)

  # data
  y = problem.data.y
  y_star = copy(y)

  # algorithm parmameters
  N = problem.N
  N_cores = problem.cores
  ϵ = problem.ϵ
  print_interval = problem.print_interval
  nbr_samples = 0


  # check inputs
  if mod(N,N_cores) != 0
    error("Select N and cores such that mod(N,cores) == 0")
  end

  # pre-allocate vectors and matricies
  theta_star = zeros(problem.dim_unknown)
  #samples_approx_posterior = zeros(length(theta_star),div(N,N_cores), N_cores)

  samples_approx_posterior = SharedArray{Float64}(length(theta_star),
                                                  div(N,N_cores),
                                                  N_cores)

  # compute summary statistics for data
  s = calc_summary(y,y)

  @printf "Starting ABC rejection sampling \n"
  @printf "Running on %d core(s)\n" N_cores
  @printf "Accuracy: ϵ: %f\n" ϵ


  @sync begin

  @parallel for n_cores = 1:N_cores
    samples_approx_posterior[:,:,n_cores] = abcrsinterationatsatcore(length(theta_star),
                                                                     div(N,N_cores),
                                                                     print_interval,
                                                                     y,
                                                                     s,
                                                                     ϵ,
                                                                     sample_from_prior,
                                                                     generate_data,
                                                                     calc_summary
                                                                     ρ)
  end

  end

  # store sample in column-major order
  samples_approx_posterior_results = reshape(samples_approx_posterior,length(theta_star),:)

  # only keep accepted proposals
  idx_keep = find(x->x != 0 ,samples_approx_posterior_results[1,:])
  samples_approx_posterior_results = samples_approx_posterior_results[:, idx_keep]

  #accaptance_rate = nbr_samples/N
  accaptance_rate = length(idx_keep)/N

  @printf "Ending ABC rejection sampling \n"
  @printf "Accaptance rate: %.2f %%\n" accaptance_rate*100

  # return samples from approxiamte posterior
  return samples_approx_posterior_results

end


function abcrsinterationatsatcore(dim_unknown::Int,
                                  iter_at_core::Int,
                                  print_interval::Int,
                                  y::Array,
                                  s::Array,
                                  ϵ::Real,
                                  sample_from_prior::Function,
                                  generate_data::Function,
                                  calc_summary::Function,
                                  ρ::Function)

  samples_approx_posterior = zeros(dim_unknown, iter_at_core)


  for n = 1:iter_at_core

    if mod(n-1,print_interval) == 0
      # print progress
      @printf "Percentage done (at each core): %.2f\n" 100*(n-1)/iter_at_core
    end

    θ_star = sample_from_prior()
    y_star = generate_data(θ_star)
    s_star = calc_summary(y_star,y)

    accept = rand() < ApproximateBayesianComputation.UniformKernel(s_star, s, ϵ, ρ)

    if accept
      samples_approx_posterior[:,n] = θ_star
    end
  end

  return samples_approx_posterior

end
