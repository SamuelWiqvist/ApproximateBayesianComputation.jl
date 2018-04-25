# test for uniform kernel

function ρ(s_star, s)
  return sum(abs(sort(s_star)-sort(s)))
end

ϵ = 0.
s = rand(4)
s_star_same = copy(s)
s_star_different = rand(4)

@testset "UniformKernel" begin
  @test UniformKernel(s_star_same, s, ϵ, ρ) == 1.
  @test UniformKernel(s_star_different, s, ϵ, ρ) == 0.
end
