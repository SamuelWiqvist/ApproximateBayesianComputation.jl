using StatsBase

# test for quantileint

data = rand(4,100)

quantile_int = ABC.calcquantileint(data, 10, 90)
quantile_def = ABC.calcquantileint(data)
quantile_trans = ABC.calcquantileint(data')

data_vec = rand(100)
quantile_vec = ABC.calcquantileint(data_vec, 10,90)
quantile_vec_def = ABC.calcquantileint(data_vec)

@testset "calcquantileint" begin
  for i = 1:4
      @test quantile(data[i,:], [0.1 0.9])[:] == quantile_int[i,:]
      @test quantile(data[i,:], [0.025 0.975])[:] == quantile_def[i,:]
      @test quantile(data[i,:], [0.025 0.975])[:] == quantile_trans[i,:]
  end
  @test quantile(data_vec, [0.1 0.9]) == quantile_vec
  @test quantile(data_vec, [0.025 0.975]) == quantile_vec_def
end

# test for RMSE

theta_true = [0.1;3;4;10]

data = repmat(theta_true, 1,100)

data_noisy = data + rand(4,100)
ABC.RMSE(theta_true, data)
ABC.RMSE(theta_true, data_noisy)

@testset "RMSE" begin
  @test ABC.RMSE(theta_true, data) == zeros(4)
  @test sum(ABC.RMSE(theta_true, data_noisy)) < 4
end
