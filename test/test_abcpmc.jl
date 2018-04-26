
# test multivariate model

include("multivariate_gaussian_gaussian_model.jl")

# test single core
data = Data(y)
ϵ_seq = [1; 0.5; 0.3]
T = length(ϵ_seq)
N = 1000
dim_unknown = 2
nbr_cores = 1
problem = ABCPMC(T,N,ϵ_seq,data,dim_unknown,cores = nbr_cores)
@everywhere srand(123) # fix random numbers
approx_posterior_samples_single_core = @time sample(problem,
                                                    sample_from_prior,
                                                    evaluate_prior,
                                                    generate_data,
                                                    calc_summary,
                                                    ρ)

# test multi-core
nbr_cores = length(workers())
problem = ABCPMC(T,N,ϵ_seq,data,dim_unknown,cores = nbr_cores)
@everywhere srand(123) # fix random numbers
approx_posterior_samples_multi_core = @time sample(problem,
                                                   sample_from_prior,
                                                   evaluate_prior,
                                                   generate_data,
                                                   calc_summary,
                                                   ρ)

# run test
@testset "ABC-PMC Gaussian-Gaussian (multivariate) (singel core)" begin
  @test sum(abs.(mean(approx_posterior_samples_single_core,2) - posterior_mean)) < 0.1
  @test sum(abs.(cov(approx_posterior_samples_single_core,2) - posterior_cov_m)) < 0.1
end

@testset "ABC-PMC Gaussian-Gaussian (multivariate) (multi-core)" begin
  @test sum(abs.(mean(approx_posterior_samples_multi_core,2) - posterior_mean)) < 0.1
  @test sum(abs.(cov(approx_posterior_samples_multi_core,2) - posterior_cov_m)) < 0.1
end




# test univariate model

include("univariate_gaussian_gaussian_model.jl")

# test single core
data = Data(y)
ϵ_seq = [1; 0.5; 0.1; 0.01]
T = length(ϵ_seq)
N = 1000
dim_unknown = 1
nbr_cores = 1
problem = ABCPMC(T,N,ϵ_seq,data,dim_unknown,cores = nbr_cores)
@everywhere srand(123) # fix random numbers
approx_posterior_samples_single_core = @time sample(problem,
                                                    sample_from_prior,
                                                    evaluate_prior,
                                                    generate_data,
                                                    calc_summary,
                                                    ρ)

# test multi-core
nbr_cores = length(workers())
problem = ABCPMC(T,N,ϵ_seq,data,dim_unknown,cores = nbr_cores)
@everywhere srand(123) # fix random numbers
approx_posterior_samples_multi_core = @time sample(problem,
                                                   sample_from_prior,
                                                   evaluate_prior,
                                                   generate_data,
                                                   calc_summary,
                                                   ρ)

# run test
@testset "ABC-PMC Gaussian-Gaussian (univariate) (singel core)" begin
  @test abs(mean(approx_posterior_samples_single_core) - posterior_mean) < 0.025
  @test abs(std(approx_posterior_samples_single_core) - posterior_std) < 0.025
end

@testset "ABC-PMC Gaussian-Gaussian (univariate) (multi-core)" begin
  @test abs(mean(approx_posterior_samples_multi_core) - posterior_mean) < 0.025
  @test abs(std(approx_posterior_samples_multi_core) - posterior_std) < 0.025
end
