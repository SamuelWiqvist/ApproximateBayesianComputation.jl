# test for uniform kernel

function ρ(s_star, s)
  return sum(abs.(sort(s_star)-sort(s)))
end

ϵ = 0.
s = rand(4)
s_star_same = copy(s)
s_star_different = rand(4)

@testset "uniform_kernel" begin
  @test uniform_kernel(s_star_same, s, ϵ, ρ) == 1.
  @test uniform_kernel(s_star_different, s, ϵ, ρ) == 0.
end

Ω_inv = inv(eye(4))
ϵ = 0.1

ρ(s_star, s) = gaussian_kernel_dist(s_star, s, Ω_inv)

@testset "GaussianKernel" begin
  kernelval1 = gaussian_kernel(1.2*s_star_same, s, ϵ, ρ)
  kernelval2 = gaussian_kernel(1.5*s_star_same, s, ϵ, ρ)
  @test kernelval1 > kernelval2
end
