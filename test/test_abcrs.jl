
# test multivariate model

include("multivariate_gaussian_gaussian_model.jl")

# test single core
data = ABC.Data(y)
nbr_cores = 1
problem = ABC.ABCRS(10^6, 0.3, data, 2, cores = nbr_cores, print_interval = 10^5)
srand(123) # fix random numbers
approx_posterior_samples_single_core = @time ABC.sample(problem,
                                                        sample_from_prior,
                                                        generate_data,
                                                        calc_summary,
                                                        ρ,
                                                        kernel)

# test multi-core
nbr_cores = length(workers())
problem = ABC.ABCRS(10^6, 0.3, data, 2, cores = nbr_cores, print_interval = 10^5)
srand(123) # fix random numbers
approx_posterior_samples_multi_core = @time ABC.sample(problem,
                                            sample_from_prior,
                                            generate_data,
                                            calc_summary,
                                            ρ,
                                            kernel)

# run test
@testset "ABC-RS Gaussian-Gaussian (multivariate) (singel core)" begin
  @test sqrt(sum((mean(approx_posterior_samples_single_core,2) - posterior_mean).^2)/2) < 0.1
  @test sqrt(sum((cov(approx_posterior_samples_single_core,2) - posterior_cov_m).^2)/4) < 0.1
end

@testset "ABC-RS Gaussian-Gaussian (multivariate) (multi-core)" begin
  @test sqrt(sum((mean(approx_posterior_samples_multi_core,2) - posterior_mean).^2)/2) < 0.1
  @test sqrt(sum((cov(approx_posterior_samples_multi_core,2) - posterior_cov_m).^2)/4) < 0.1
end


# test univariate model

include("univariate_gaussian_gaussian_model.jl")

# test single core
data = ABC.Data(y)
nbr_cores = 1
problem = ABC.ABCRS(10^6, 0.01, data, 1, cores = nbr_cores, print_interval = 10^5)
srand(123) # fix random numbers
approx_posterior_samples_single_core = @time ABC.sample(problem,
                                                        sample_from_prior,
                                                        generate_data,
                                                        calc_summary,
                                                        ρ,
                                                        kernel)

# test multi-core
nbr_cores = length(workers())
problem = ABC.ABCRS(10^6, 0.01, data, 1, cores = nbr_cores, print_interval = 10^5)
srand(123) # fix random numbers
approx_posterior_samples_multi_core = @time ABC.sample(problem,
                                            sample_from_prior,
                                            generate_data,
                                            calc_summary,
                                            ρ,
                                            kernel)

# run test
@testset "ABC-RS Gaussian-Gaussian (univariate) (singel core)" begin
  @test abs(mean(approx_posterior_samples_single_core) - posterior_mean) < 0.01
  @test abs(std(approx_posterior_samples_single_core) - posterior_std) < 0.01
end

@testset "ABC-RS Gaussian-Gaussian (univariate) (multi-core)" begin
  @test abs(mean(approx_posterior_samples_multi_core) - posterior_mean) < 0.01
  @test abs(std(approx_posterior_samples_multi_core) - posterior_std) < 0.01
end
