# test for Euclidean distance function
s = rand(4)
s_star_same = copy(s)
s_star_different = rand(4)
w = ones(4)

@testset "euclidean_dist distance function" begin
  @test euclidean_dist(s_star_same, s, w) == 0
  @test euclidean_dist(s_star_different, s, w) != 0
end

# need to add test for gaussian_kernel_dist
Ω_inv = inv(diagm(w))

@testset "gaussian_kernel_dist distance function" begin
  @test gaussian_kernel_dist(s_star_same, s, Ω_inv) == 0
  gaussian_kernel_dist(s_star_same, s, Ω_inv) != 0
end
