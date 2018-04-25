# test for Euclidian distance function
s = rand(4)
s_star_same = copy(s)
s_star_different = rand(4)
w = ones(4)

@testset "Euclidian distance function" begin
  @test ABC.Euclidian(s_star_same, s, w) == 0
  @test ABC.Euclidian(s_star_different, s, w) != 0
end
