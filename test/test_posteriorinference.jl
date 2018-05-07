using StatsBase

# test for quantileint

data = rand(4,100)

quantile_int = quantile_interval(data, lower=10, upper=90)
quantile_def = quantile_interval(data)
quantile_trans = quantile_interval(data')

data_vec = rand(100)
quantile_vec = quantile_interval(data_vec, lower=10, upper=90)
quantile_vec_def = quantile_interval(data_vec)

@testset "quantile_interval" begin
  for i = 1:4
      @test quantile(data[i,:], [0.1 0.9])[:] == quantile_int[i,:]
      @test quantile(data[i,:], [0.025 0.975])[:] == quantile_def[i,:]
      @test quantile(data[i,:], [0.025 0.975])[:] == quantile_trans[i,:]
  end
  @test quantile(data_vec, [0.1 0.9]) == quantile_vec
  @test quantile(data_vec, [0.025 0.975]) == quantile_vec_def
end

# test for RMSE

theta_true = 2.
theta_est_true = 2.
theta_est = 2. + 0.2*rand()

@testset "loss 1D" begin
  @test loss(theta_true, theta_est_true) == 0
  @test loss(theta_true, theta_est) > 0
end

theta_true = [0.1;3;4;10]
theta_est_true = copy(theta_true)
theta_est = copy(theta_true) + 0.2*rand(4)

@testset "loss multi-D" begin
  @test sum(loss(theta_true,theta_est_true)) == 0.
  @test sum(loss(theta_true, theta_est)) > 0
end
