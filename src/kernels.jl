doc"""
    UniformKernel(s_star::Vector, s::Vector, ϵ::Real, ρ)

The Uniform kernel function.
"""
function UniformKernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)

  if ρ(s_star,s) <= ϵ
    return 1.
  else
    return 0.
  end

end

doc"""
    GaussianKernel(s_star::Vector, s::Vector, Ω_inv::Array, ϵ::Real)

The Gaussian kernel function.
"""
function GaussianKernel(s_star::Vector, s::Vector, Ω_inv::Array, ϵ::Real)

  Δs =  (s_star-s)
  dist = Δs'*Ω_inv*Δs

  return exp(-dist/(2*ϵ^2))

end
