# test multivariate model
include("multivariate_gaussian_gaussian_model.jl")


# create ABC-MCMC problem
ϵ_seq = [10*ones(1000);5*ones(1000);2*ones(1000); 1*ones(1000);0.8*ones(1000);0.5*ones(500000)] # ; 0.05*ones(100000)
burn_in = length(ϵ_seq)-500000
N = length(ϵ_seq)
dim_unknown = 2
θ_start =  ones(2)
adaptive_update = noAdaptation([0.05; 0.05])
data = Data(y)
problem = ABCMCMC(N, burn_in, ϵ_seq, dim_unknown, θ_start, "none", data, adaptive_update,
                  print_interval = 10^5)


# run ABC-MCMC
srand(123) # fix random numbers
chain_original = @time sample(problem,
                              sample_from_prior,
                              evaluate_prior,
                              generate_data,
                              calc_summary,
                              ρ)

problem = ABCMCMC(N, burn_in, ϵ_seq, dim_unknown, θ_start, "none", data, adaptive_update,
                  algorithm_type = "general", print_interval = 10^5)


# run ABC-MCMC
srand(123) # fix random numbers
chain_general = @time sample(problem,
                                  sample_from_prior,
                                  evaluate_prior,
                                  generate_data,
                                  calc_summary,
                                  ρ)


# run test
@testset "ABC-MCMC Gaussian-Gaussian (multivariate) (original)" begin
  @test sum(abs.(mean(chain_original[:,burn_in:end],2)  - posterior_mean)) < 0.1
  @test sum(abs.(cov(chain_original[:,burn_in:end],2) - posterior_cov_m)) < 0.1
end



@testset "ABC-MCMC Gaussian-Gaussian (multivariate) (general)" begin
  @test sum(abs.(mean(chain_general[:,burn_in:end],2)  - posterior_mean)) < 0.1
  @test sum(abs.(cov(chain_general[:,burn_in:end],2) - posterior_cov_m)) < 0.1
end

# test univariate model

include("univariate_gaussian_gaussian_model.jl")

# create ABC-MCMC problem
ϵ_seq = [1*ones(1000);0.5*ones(1000);0.2*ones(1000); 0.1*ones(1000); 0.05*ones(1000);0.01*ones(500000)] # ; 0.05*ones(100000)
burn_in = length(ϵ_seq)-500000
N = length(ϵ_seq)
dim_unknown = 1
θ_start =  [1.]
adaptive_update = noAdaptation([0.1])
data = Data(y)
problem = ABCMCMC(N, burn_in, ϵ_seq, dim_unknown, θ_start, "none", data, adaptive_update,
                  print_interval = 10^5)


# run ABC-MCMC
srand(123) # fix random numbers
chain_original = @time sample(problem,
                              sample_from_prior,
                              evaluate_prior,
                              generate_data,
                              calc_summary,
                              ρ)


problem = ABCMCMC(N, burn_in, ϵ_seq, dim_unknown, θ_start, "none", data,  adaptive_update,
                  algorithm_type = "general", print_interval = 10^5)

# run ABC-MCMC
srand(123) # fix random numbers
chain_general = @time sample(problem,
                            sample_from_prior,
                            evaluate_prior,
                            generate_data,
                            calc_summary,
                            ρ)

# run tests
@testset "ABC-MCMC Gaussian-Gaussian (univariate) (original)" begin
  @test abs(mean(chain_original[burn_in:end]) - posterior_mean) < 0.025
  @test abs(std(chain_original[burn_in:end]) - posterior_std) < 0.025
end

@testset "ABC-MCMC Gaussian-Gaussian (univariate) (general)" begin
  @test abs(mean(chain_general[burn_in:end]) - posterior_mean) < 0.025
  @test abs(std(chain_general[burn_in:end]) - posterior_std) < 0.025
end
