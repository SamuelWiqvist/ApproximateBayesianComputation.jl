# test for uniform kernel

function ρ(s_star, s)
  return sum(abs.(sort(s_star)-sort(s)))
end

ϵ = 0.
s = rand(4)
s_star_same = copy(s)
s_star_different = rand(4)

@testset "UniformKernel" begin
  @test UniformKernel(s_star_same, s, ϵ, ρ) == 1.
  @test UniformKernel(s_star_different, s, ϵ, ρ) == 0.
end

#=
Ω = eye(4)
Ω_inv = inv(Ω)
ϵ = 0.1
@testset "GaussianKernel" begin
  @test GaussianKernel(s_star_same, s, Ω_inv, ϵ) == 1.
  kernelval1 = GaussianKernel(1.2*s_star_same, s, Ω_inv, ϵ)
  kernelval2 = GaussianKernel(1.5*s_star_same, s, Ω_inv, ϵ)
  @test kernelval1 > kernelval2
end
=#
