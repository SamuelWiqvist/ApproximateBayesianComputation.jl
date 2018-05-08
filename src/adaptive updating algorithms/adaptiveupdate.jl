# abstract type
abstract type  AdaptationAlgorithm end


# typs
"""
    FixedKernel

Fixed proposal distribution.

Parameters:

* `Cov::Array{Real}` covaraince matrix
"""
type FixedKernel <: AdaptationAlgorithm
  Cov::Array{Real}
end

"""
    AMUpdate

Adaptive tuning of the proposal distribution. Sources: *A tutorial on adaptive MCMC* [https://link.springer.com/article/10.1007/s11222-008-9110-y](https://link.springer.com/article/10.1007/s11222-008-9110-y),
and *Exploring the common concepts of adaptive MCMC and Covariance Matrix Adaptation schemes* [http://drops.dagstuhl.de/opus/volltexte/2010/2813/pdf/10361.MuellerChristian.Paper.2813.pdf](http://drops.dagstuhl.de/opus/volltexte/2010/2813/pdf/10361.MuellerChristian.Paper.2813.pdf)

Parameters:

* `C_0::Array{Real}`
* `r_cov_m::Real`
* `gamma_0::Real`
* `k::Real`
* `t_0::Integer`
"""
type AMUpdate <: AdaptationAlgorithm
  C_0::Array{Real}
  r_cov_m::Real
  gamma_0::Real
  k::Real
  t_0::Integer
end

# functions

# set up functions
function set_adaptive_alg_params(algorithm::FixedKernel, nbr_of_unknown_parameters::Integer, theta::Vector,R::Integer)

  return (algorithm.Cov, NaN)

end

function set_adaptive_alg_params(algorithm::AMUpdate, nbr_of_unknown_parameters::Integer, theta::Vector,R::Integer)

  # define m_g m_g_1
  m_g = zeros(nbr_of_unknown_parameters,1)
  m_g_1 = zeros(nbr_of_unknown_parameters,1)

  return (algorithm.C_0, algorithm.gamma_0, algorithm.k, algorithm.t_0, [algorithm.r_cov_m], m_g, m_g_1)

end


# return covariance functions
function return_covariance_matrix(algorithm::FixedKernel, adaptive_update_params::Tuple,r::Integer)

  return adaptive_update_params[1]

end

function return_covariance_matrix(algorithm::AMUpdate, adaptive_update_params::Tuple,r::Integer)
    r_cov_m = adaptive_update_params[end-2][1]
    Cov_m = adaptive_update_params[1]
    return r_cov_m^2*Cov_m
end


# print_covariance functions
function print_covariance(algorithm::FixedKernel, adaptive_update_params::Tuple,r::Integer)

  println(adaptive_update_params[1])

end

function print_covariance(algorithm::AMUpdate, adaptive_update_params::Tuple,r::Integer)
    r_cov_m = adaptive_update_params[end-2][1]
    Cov_m = adaptive_update_params[1]
    println(r_cov_m^2*Cov_m)
end


# get_covariance functions
function get_covariance(algorithm::FixedKernel, adaptive_update_params::Tuple,r::Integer)

  return adaptive_update_params[1]

end

function get_covariance(algorithm::AMUpdate, adaptive_update_params::Tuple,r::Integer)
    r_cov_m = adaptive_update_params[end-2][1]
    Cov_m = adaptive_update_params[1]
    return r_cov_m^2*Cov_m
end


# gaussian random walk functions
function gaussian_random_walk(algorithm::FixedKernel, adaptive_update_params::Tuple, Theta::Vector, r::Integer)

  return rand(MvNormal(Theta, 1.0*adaptive_update_params[1])), zeros(size(Theta))

end

function gaussian_random_walk(algorithm::AMUpdate, adaptive_update_params::Tuple, Theta::Vector, r::Integer)
  r_cov_m = adaptive_update_params[end-2][1]
  Cov_m = adaptive_update_params[1]
  return rand(MvNormal(Theta, r_cov_m^2*Cov_m)), zeros(size(Theta))
end


# functions for adaptation of parameters
function adaptation(algorithm::FixedKernel, adaptive_update_params::Tuple, Theta::Array, r::Integer,a_log::Real)

  # do nothing

end

function adaptation(algorithm::AMUpdate, adaptive_update_params::Tuple, Theta::Array, r::Integer,a_log::Real)

  Cov_m = adaptive_update_params[1]
  m_g = adaptive_update_params[end-1]
  m_g_1 = adaptive_update_params[end]
  k = adaptive_update_params[3]
  gamma_0 = adaptive_update_params[2]
  t_0 = adaptive_update_params[4]

  g = r-1
  if r-1 == t_0
      m_g = mean(Theta[:,1:r-1],2)
      m_g_1 = m_g + gamma_0/( (g+1)^k ) * (Theta[:,g+1] - m_g)
      adaptive_update_params[1][:] = Cov_m + ( gamma_0/( (g+1)^k ) ) * ( (Theta[:, g+1] - m_g)*(Theta[:,g+1] - m_g)'     -  Cov_m)
      adaptive_update_params[end-1][:] = m_g_1
  elseif r-1 > t_0
      m_g_1 = m_g + gamma_0/( (g+1)^k ) * (Theta[:,g+1] - m_g)
      adaptive_update_params[1][:] = Cov_m + ( gamma_0/( (g+1)^k ) ) * ( (Theta[:, g+1] - m_g)*(Theta[:,g+1] - m_g)'     -  Cov_m)
      adaptive_update_params[end-1][:] = m_g_1
  end

end
