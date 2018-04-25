doc"""
    UniformKernel(s_star::Vector, s::Vector, ϵ::Real, ρ)

The uniform kernel function.
"""
function UniformKernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)

  if ρ(s_star,s) <= ϵ
    return 1.
  else
    return 0.
  end

end

doc"""
    GaussianKernel(s_star::Vector, s::Vector, ϵ::Real, ρ)

The uniform kernel function.
"""
function GaussianKernel(s_star::Vector, s::Vector, Ω_inv::Real)

  return exp(-(s_star-s)*Ω_inv*(s_star-s))

end
