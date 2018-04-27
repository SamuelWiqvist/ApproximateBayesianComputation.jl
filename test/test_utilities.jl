a = 0
b = 10


@testset "log_unifpdf" begin
  @test log_unifpdf(0.5, a, b) == -log(b-a)
  @test log_unifpdf(11, a, b) == -Inf
end
