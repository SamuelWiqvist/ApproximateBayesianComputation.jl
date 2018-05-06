@everywhere using Distributions

# univariate Gaussian-Gaussian model
@everywhere μ = 0
@everywhere σ = 1
@everywhere n = 100

srand(111) # fix random numbers
y_univar = rand(Normal(μ,σ),100)

@everywhere μ_0_univar = 0.1
@everywhere σ_0 = 1.

λ = 1/σ^2
λ_0 = 1/σ_0^2
σ_n2 = 1/(n/σ^2 + 1/σ_0^2)
λ_n = 1/σ_n2

posterior_mean_univar = (mean(y_univar)*n*λ + μ_0_univar*λ_0) / λ_n
posterior_std = sqrt(1/(λ_0 + n*λ))

@everywhere sample_from_prior_univar() = rand(Normal(μ_0_univar, σ_0))
@everywhere generate_data_univar(μ) = typeof(μ) <: Real ? rand(Normal(μ,σ),n) : rand(Normal(μ[1],σ),n)
@everywhere calc_summary_univar(y_star,y) = [mean(y_star); std(y_star)]
@everywhere ρ_univar(s_star, s) = euclidean_dist(s_star, s, ones(2))
@everywhere kernel_univar(s_star::Vector, s::Vector, ϵ::Real, ρ::Function) = uniform_kernel(s_star, s, ϵ, ρ)
@everywhere evaluate_prior_univar(Θ) = pdf.(Normal(μ_0_univar, σ_0), Θ)[1]

# multivariate Gaussian-Gaussian model
@everywhere μ = [0.;0]
@everywhere Σ = [1. 0;0 1]
@everywhere n = 100

srand(111) # fix random numbers
y_multivar = rand(MvNormal(μ,Σ),100)

@everywhere μ_0_multivar = [0.1;0.1]
@everywhere Σ_0 = 0.2*[1. 0;0 1]


posterior_cov_m = inv(inv(Σ_0) + n*inv(Σ))
posterior_mean_multivar = posterior_cov_m*(n*inv(Σ)*mean(y_multivar,2) + inv(Σ_0)*μ_0_multivar)

@everywhere sample_from_prior_multivar() = rand(MvNormal(μ_0_multivar, Σ_0))
@everywhere generate_data_multivar(μ) = rand(MvNormal(μ,Σ),n)
@everywhere calc_summary_multivar(y_star,y) = [mean(y_star,2)[:]; var(y_star,2)[:]; cov(y_star)[1,2]]
@everywhere ρ_multivar(s_star, s) = euclidean_dist(s_star, s, ones(5))
@everywhere kernel_multivar(s_star::Vector, s::Vector, ϵ::Real, ρ::Function) = uniform_kernel(s_star, s, ϵ, ρ)
@everywhere evaluate_prior_multivar(θ) = pdf(MvNormal(μ_0_multivar, Σ_0), θ)[1]
