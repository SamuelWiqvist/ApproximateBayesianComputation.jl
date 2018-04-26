@everywhere using Distributions

@everywhere μ = 0
@everywhere σ = 1
@everywhere n = 100

srand(111) # fix random numbers
y = rand(Normal(μ,σ),100)

@everywhere μ_0 = 0.1
@everywhere σ_0 = 1.

λ = 1/σ^2
λ_0 = 1/σ_0^2
σ_n2 = 1/(n/σ^2 + 1/σ_0^2)
λ_n = 1/σ_n2

posterior_mean = (mean(y)*n*λ + μ_0*λ_0) / λ_n
posterior_std = sqrt(1/(λ_0 + n*λ))

@everywhere sample_from_prior() = rand(Normal(μ_0, σ_0))
@everywhere generate_data(μ) = typeof(μ) <: Real ? rand(Normal(μ,σ),n) : rand(Normal(μ[1],σ),n)
@everywhere calc_summary(y_star,y) = [mean(y_star); std(y_star)]
@everywhere ρ(s_star, s) = Euclidean(s_star, s, ones(2))
@everywhere kernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function) = UniformKernel(s_star, s, ϵ, ρ)
@everywhere evaluate_prior(Θ) = pdf(Normal(μ_0, σ_0), Θ)[1]
