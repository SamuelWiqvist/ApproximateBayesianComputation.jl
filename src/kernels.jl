doc"""
    UniformKernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)

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
    GaussianKernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)

The Gaussian kernel function.
"""
function GaussianKernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)

  return exp(-ρ(s_star,s)/(2*ϵ^2))

end
