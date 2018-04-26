# type
"""
Type for defining a problem for the ABC rejection sampling algorithm

Parameters:

- `T::Int` nbr of iterations
- `N::Int` nbr of samples in the population
- `ϵ::Real` start threshold
- `data::Data` data
- `dim_unknown::Int` nbr of unknown parameters
- `cores::Int` nbr of course (default value 1)
- `print_interval::Int` print state of algorithm at every `print_interval`th iteration (default value 1000)
"""
type PMCABC <: ABCAlgorithm
  T::Int # nbr of iterations
  N::Int # nbr of samples in the population
  ϵ_seq::Vector # start threshold
  data::Data # data
  dim_unknown::Int # nbr of unknown parameters
  cores::Int # nbr of course
  print_interval::Int # print interval for stats of algorithm
end

# constructor
PMCABC(T::Int, N::Int,ϵ_seq::Vector, data::Data, dim_unknown::Int; cores::Int=1, print_interval::Int = 1) = PMCABC(T,N, ϵ_seq, data, dim_unknown, cores, print_interval)

# method
"""
    sample(problem::PMCABC,
        sample_from_prior::Function,
        evaluate_prior::Function,
        generate_data::Function,
        calc_summary::Function,
        ρ::Function)

Sample from the approximate posterior distribtuion using PMC-ABC algorithm
described in Adaptive approximate Bayesian computation< http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.313.3573&rep=rep1&type=pdf.

Input:
- `problem::PMCABC` problem
- `sample_from_prior::Function` function to sample from the prior
- `generate_data::Function` function to generate data from the model
- `calc_summary::Function` function to calculate summary statistics
- `ρ::Function` the distance function

Output:

- `θ_pop::Matrix` last population

"""
function sample(problem::PMCABC,
                sample_from_prior::Function,
                evaluate_prior::Function,
                generate_data::Function,
                calc_summary::Function,
                ρ::Function)

  # data
  y = problem.data.y
  y_star = copy(y)

  # algorithm parmameters
  T = problem.T
  N = problem.N
  ϵ = problem.ϵ_seq
  print_interval = problem.print_interval
  nbr_samples = 0
  accept = false
  ϵ_seq = problem.ϵ_seq
  N_cores = problem.cores

  # pre-allocate vectors and matricies
  dim_unknown = problem.dim_unknown
  w_old = zeros(N)
  w_new = zeros(N)
  θ_pop_old = zeros(dim_unknown,N)
  θ_pop = zeros(dim_unknown,N)
  τ_2 = zeros(dim_unknown)

  # check inputs
  if mod(N,N_cores) != 0
    error("Select N and cores such that mod(N,cores) == 0")
  end

  # pre-allocate matricies
  θ_pop_parallel = SharedArray{Float64}(dim_unknown,div(N,N_cores), N_cores)
  accaptance_rate = SharedArray{Float64}(N_cores)

  @printf "Starting PMC-ABC \n"
  @printf "Running on %d core(s)\n" N_cores
  @printf "Starting Threshold: ϵ: %.4f\n" ϵ_seq[1]

  # compute summary statistics for data
  s = calc_summary(y,y)

  @sync begin

  # set start population (in parallel)
  @parallel for i = 1:N_cores
    θ_pop_parallel[:,:,i], accaptance_rate[i] = pmcabcstartvalatcores(sample_from_prior,
                                                                      generate_data,
                                                                      calc_summary,
                                                                      ρ,
                                                                      dim_unknown,
                                                                      N,
                                                                      N_cores,
                                                                      ϵ_seq[1],
                                                                      y,
                                                                      s)
  end

  end

  θ_pop_old = reshape(θ_pop_parallel,dim_unknown,:)

  # initlize start weigths
  @inbounds for i = 1:N
    w_old[i] = 1/N
  end

  # main loop
  for t = 2:T

    # set variance for Gaussian perturbation distribtuion
    τ_2 = 2*var(θ_pop_old,2)[:]

    # print progress
    if mod(t-1,print_interval) == 0
      @printf "Iteraton: %d \n" t
      # print progress
      @printf "Percentage done: %.2f %% \n" 100*(t-1)/T
      # print threshold
      @printf "Threshold (current iteration): %.4f \n"  ϵ_seq[t]
      # print accaptace rate
      @printf "Accaptace rate (previous iteration): %.4f %%\n"  mean(accaptance_rate)*100

    end

    @sync begin

    # update population (in parallel)
    @parallel for i = 1:N_cores
      θ_pop_parallel[:,:,i], accaptance_rate[i] = pmcabcpropatcores(w_old,
                                                                    θ_pop_old,
                                                                    τ_2,
                                                                    dim_unknown,
                                                                    s,
                                                                    ϵ_seq[t],
                                                                    N,
                                                                    N_cores,
                                                                    generate_data,
                                                                    calc_summary,
                                                                    ρ,
                                                                    y)
    end

    end

    # set new population
    θ_pop = reshape(θ_pop_parallel,dim_unknown,:)

    # compute weigths
    for i = 1:N
      sum_w_update = 0.
      for j = 1:N
        sum_w_update = sum_w_update + w_old[j]*pdf(MvNormal(θ_pop_old[:,j], diagm(sqrt.(τ_2))), θ_pop[:,i])
      end
      w_new[i] = evaluate_prior(θ_pop[:,i])/sum_w_update
    end

    # normalize weigths
    w_new = w_new/sum(w_new)

    # update weigths and population
    w_old = w_new
    θ_pop_old = θ_pop

  end

  @printf "Accaptace rate (final iteration): %.4f %%\n"  mean(accaptance_rate)*100
  @printf "Ending PMC-ABC \n"

  # return last population
  return Array(θ_pop)

end

# help functions

"""
    pmcabcstartvalatcores(sample_from_prior::Function,
                          generate_data::Function,
                          calc_summary::Funciton,
                          N::Int,
                          N_cores::Int)

Runs the first iteration of the PMC-SMC algorithm for N/N_cores particels,
in parallel at N_cores cores.
"""
function pmcabcstartvalatcores(sample_from_prior::Function,
                               generate_data::Function,
                               calc_summary::Function,
                               ρ::Function,
                               dim_unknown::Int,
                               N::Int,
                               N_cores::Int,
                               ϵ_val::Real,
                               y::Array,
                               s::Vector)

  θ_pop_old_at_core = zeros(dim_unknown, div(N, N_cores))
  θ_star = zeros(dim_unknown)
  accaptance_rate = zeros(div(N,N_cores))

  for i = 1:div(N,N_cores)
    accept = false
    while accept == false
      θ_star = sample_from_prior()
      y_star = generate_data(θ_star)
      s_star = calc_summary(y_star,y)
      accept = Bool(ABC.UniformKernel(s_star, s, ϵ_val, ρ))
      accaptance_rate[i] = accaptance_rate[i] + 1.
    end
    accaptance_rate[i] = 1/accaptance_rate[i]
    θ_pop_old_at_core[:,i] = θ_star
  end

  return θ_pop_old_at_core, mean(accaptance_rate)

end

"""
    pmcabcpropatcores(w_old::Vector,
                      θ_pop_old::Matrix,
                      τ_2::Vector,
                      dim_unknown::Int,
                      s::Vector,
                      ϵ_val::Real,
                      N::Int,
                      N_cores::Int,
                      sample_from_prior::Function,
                      generate_data::Function,
                      calc_summary::Function)

Updates the population for N/N_cores particels in parallel at N_cores cores.
"""
function pmcabcpropatcores(w_old::Vector,
                           θ_pop_old::Base.ReshapedArray,
                           τ_2::Vector,
                           dim_unknown::Int,
                           s::Vector,
                           ϵ_val::Real,
                           N::Int,
                           N_cores::Int,
                           generate_data::Function,
                           calc_summary::Function,
                           ρ::Function,
                           y::Array)


  θ_pop_at_core = zeros(dim_unknown, div(N, N_cores))
  θ_star = zeros(dim_unknown)
  accaptance_rate = zeros(div(N,N_cores))

  # create resampling dist
  resampling_dist = Categorical(w_old)

  # update population
  for i = 1:div(N, N_cores)
    accept = false
    accaptance_rate[i] = 0.
    while accept == false
      idx_star = rand(resampling_dist)
      θ_star = θ_pop_old[:,idx_star]
      for dim = 1:dim_unknown # devectorized loop over the dimension
        # perturbate particle
        θ_star[dim] = θ_star[dim] +  sqrt(τ_2[dim])*randn()
      end
      y_star = generate_data(θ_star)
      s_star = calc_summary(y_star,y)
      accept = Bool(ABC.UniformKernel(s_star, s, ϵ_val, ρ))
      accaptance_rate[i] = accaptance_rate[i] + 1.
    end
    accaptance_rate[i] = 1/accaptance_rate[i]
    θ_pop_at_core[:,i] = θ_star
  end

  return θ_pop_at_core, mean(accaptance_rate)

end
