@everywhere using ABC
@everywhere using Distributions

@everywhere μ = [0.;0]
@everywhere Σ = [1. 0;0 1]
@everywhere n = 100

srand(111) # fix random numbers
y = rand(MvNormal(μ,Σ),100)

@everywhere μ_0 = [0.1;0.1]
@everywhere Σ_0 = 0.2*[1. 0;0 1]


posterior_cov_m = inv(inv(Σ_0) + n*inv(Σ))
posterior_mean = posterior_cov_m*(n*inv(Σ)*mean(y,2) + inv(Σ_0)*μ_0)

@everywhere sample_from_prior() = rand(MvNormal(μ_0, Σ_0))
@everywhere generate_data(μ) = rand(MvNormal(μ,Σ),n)
@everywhere calc_summary(y_star,y) = [mean(y_star,2)[:]; var(y_star,2)[:]; cov(y_star)[1,2]]
@everywhere ρ(s_star, s) = ABC.Euclidean(s_star, s, [1;1;1;1;1])
@everywhere kernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function) = ABC.UniformKernel(s_star, s, ϵ, ρ)
@everywhere evaluate_prior(θ) = pdf(MvNormal(μ_0, Σ_0), θ)[1]
