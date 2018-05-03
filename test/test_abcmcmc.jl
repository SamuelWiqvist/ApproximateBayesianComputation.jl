# test multivariate model

# create ABC-MCMC problem
ϵ_seq = [2*ones(100000);1*ones(100000); 0.8*ones(100000);0.5*ones(100000);0.3*ones(500000)] # ; 0.05*ones(100000)
burn_in = length(ϵ_seq)-500000
N = length(ϵ_seq)
dim_unknown = 2
θ_start =  ones(2)
adaptive_update = noAdaptation([0.05;0.05])
data = Data(y_multivar)
problem = ABCMCMC(N, burn_in, ϵ_seq, dim_unknown, θ_start, "none", data, adaptive_update,
                  print_interval = 10^5)

# run ABC-MCMC
srand(123) # fix random numbers
chain_original = @time sample(problem,
                              sample_from_prior_multivar,
                              evaluate_prior_multivar,
                              generate_data_multivar,
                              calc_summary_multivar,
                              ρ_multivar)

problem = ABCMCMC(N, burn_in, ϵ_seq, dim_unknown, θ_start, "none", data, adaptive_update,
                  algorithm_type = "general", print_interval = 10^5)

# run ABC-MCMC
srand(123) # fix random numbers
chain_general = @time sample(problem,
                             sample_from_prior_multivar,
                             evaluate_prior_multivar,
                             generate_data_multivar,
                             calc_summary_multivar,
                             ρ_multivar)


# run test
@testset "ABC-MCMC Gaussian-Gaussian (multivariate) (original)" begin
  @test sum(abs.(mean(chain_original[:,burn_in:end],2)  - posterior_mean_multivar)) < 0.1
  @test sum(abs.(cov(chain_original[:,burn_in:end],2) - posterior_cov_m)) < 0.1
end

@testset "ABC-MCMC Gaussian-Gaussian (multivariate) (general)" begin
  @test sum(abs.(mean(chain_general[:,burn_in:end],2)  - posterior_mean_multivar)) < 0.1
  @test sum(abs.(cov(chain_general[:,burn_in:end],2) - posterior_cov_m)) < 0.1
end

# test univariate model

# create ABC-MCMC problem
ϵ_seq = [1*ones(1000);0.5*ones(1000);0.2*ones(1000); 0.1*ones(1000); 0.05*ones(1000);0.01*ones(500000)] # ; 0.05*ones(100000)
burn_in = length(ϵ_seq)-500000
N = length(ϵ_seq)
dim_unknown = 1
θ_start =  [1.]
adaptive_update = noAdaptation([0.1])
data = Data(y_univar)
problem = ABCMCMC(N, burn_in, ϵ_seq, dim_unknown, θ_start, "none", data, adaptive_update,
                  print_interval = 10^5)


# run ABC-MCMC
srand(123) # fix random numbers
chain_original = @time sample(problem,
                              sample_from_prior_univar,
                              evaluate_prior_univar,
                              generate_data_univar,
                              calc_summary_univar,
                              ρ_univar)


problem = ABCMCMC(N, burn_in, ϵ_seq, dim_unknown, θ_start, "none", data,  adaptive_update,
                  algorithm_type = "general", print_interval = 10^5)

# run ABC-MCMC
srand(123) # fix random numbers
chain_general = @time sample(problem,
                            sample_from_prior_univar,
                            evaluate_prior_univar,
                            generate_data_univar,
                            calc_summary_univar,
                            ρ_univar)

# run tests
@testset "ABC-MCMC Gaussian-Gaussian (univariate) (original)" begin
  @test abs(mean(chain_original[burn_in:end]) - posterior_mean_univar) < 0.1
  @test abs(std(chain_original[burn_in:end]) - posterior_std) < 0.1
end

@testset "ABC-MCMC Gaussian-Gaussian (univariate) (general)" begin
  @test abs(mean(chain_general[burn_in:end]) - posterior_mean_univar) < 0.1
  @test abs(std(chain_general[burn_in:end]) - posterior_std) < 0.1
end
