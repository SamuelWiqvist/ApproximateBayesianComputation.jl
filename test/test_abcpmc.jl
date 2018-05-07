
# test input
ϵ_seq = [1; 0.5; 0.3]
T = length(ϵ_seq)
N = 500
dim_unknown = 2

problem_error = ABCPMC(T,N,ϵ_seq,Data(y_multivar),dim_unknown,cores = 3)

function test_input()
  try
    sample(problem_error,
          sample_from_prior_multivar,
          evaluate_prior_multivar,
          generate_data_multivar,
          calc_summary_multivar,
          ρ_multivar)
  catch err
    return err
  end
end

@testset "ABC-PMC Gaussian-Gaussian (test input values )" begin
  @test typeof(test_input()) == ErrorException
end


# test multivariate model

# test single core
ϵ_seq = [1; 0.5; 0.3]
T = length(ϵ_seq)
N = 500
dim_unknown = 2
nbr_cores = 1
problem = ABCPMC(T,N,ϵ_seq,Data(y_multivar),dim_unknown,cores = nbr_cores)
@everywhere srand(123) # fix random numbers
approx_posterior_samples_single_core = @time sample(problem,
                                                    sample_from_prior_multivar,
                                                    evaluate_prior_multivar,
                                                    generate_data_multivar,
                                                    calc_summary_multivar,
                                                    ρ_multivar)

# test multi-core
nbr_cores = length(workers())
problem = ABCPMC(T,N,ϵ_seq,Data(y_multivar),dim_unknown,cores = nbr_cores)
@everywhere srand(123) # fix random numbers
approx_posterior_samples_multi_core = @time sample(problem,
                                                   sample_from_prior_multivar,
                                                   evaluate_prior_multivar,
                                                   generate_data_multivar,
                                                   calc_summary_multivar,
                                                   ρ_multivar)

# run test
@testset "ABC-PMC Gaussian-Gaussian (multivariate) (singel core)" begin
  @test sum(abs.(mean(approx_posterior_samples_single_core,2) - posterior_mean_multivar)) < 0.1
  @test sum(abs.(cov(approx_posterior_samples_single_core,2) - posterior_cov_m)) < 0.1
end

@testset "ABC-PMC Gaussian-Gaussian (multivariate) (multi-core)" begin
  @test sum(abs.(mean(approx_posterior_samples_multi_core,2) - posterior_mean_multivar)) < 0.1
  @test sum(abs.(cov(approx_posterior_samples_multi_core,2) - posterior_cov_m)) < 0.1
end


# test univariate model

# test single core
ϵ_seq = [1; 0.5; 0.1; 0.01]
T = length(ϵ_seq)
N = 500
dim_unknown = 1
nbr_cores = 1
problem = ABCPMC(T,N,ϵ_seq,Data(y_univar),dim_unknown,cores = nbr_cores)
@everywhere srand(123) # fix random numbers
approx_posterior_samples_single_core = @time sample(problem,
                                                    sample_from_prior_univar,
                                                    evaluate_prior_univar,
                                                    generate_data_univar,
                                                    calc_summary_univar,
                                                    ρ_univar)

# test multi-core
nbr_cores = length(workers())
problem = ABCPMC(T,N,ϵ_seq,Data(y_multivar),dim_unknown,cores = nbr_cores)
@everywhere srand(123) # fix random numbers
approx_posterior_samples_multi_core = @time sample(problem,
                                                   sample_from_prior_univar,
                                                   evaluate_prior_univar,
                                                   generate_data_univar,
                                                   calc_summary_univar,
                                                   ρ_univar)

# run test
@testset "ABC-PMC Gaussian-Gaussian (univariate) (singel core)" begin
  @test abs(mean(approx_posterior_samples_single_core) - posterior_mean_univar) < 0.1
  @test abs(std(approx_posterior_samples_single_core) - posterior_std) < 0.1
end

@testset "ABC-PMC Gaussian-Gaussian (univariate) (multi-core)" begin
  @test abs(mean(approx_posterior_samples_multi_core) - posterior_mean_univar) < 0.1
  @test abs(std(approx_posterior_samples_multi_core) - posterior_std) < 0.1
end
