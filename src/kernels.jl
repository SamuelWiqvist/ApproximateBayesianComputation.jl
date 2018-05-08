doc"""
    uniform_kernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)

The Uniform kernel function follows

``
K^{\text{Uniform}}_{\epsilon}(\rho(x,y)) = \begin{cases}
        1, \text{if}, \rho(x,y) \le \epsilon,
        \\
        0, \text{otherwise}.
        \end{cases}
``

"""
function uniform_kernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)

  if ρ(s_star,s) <= ϵ
    return 1.
  else
    return 0.
  end

end

doc"""
    gaussian_kernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)

The Gaussian kernel function follows

``K^{\text{Gaussian}}_{\epsilon}(x,y) \propto \exp(-\rho_{\text{Gaussian}}(x,y)/2\epsilon^2).``

"""
function gaussian_kernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)

  return exp(-ρ(s_star,s)/(2*ϵ^2))

end
