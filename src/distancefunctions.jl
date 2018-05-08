
doc"""
    euclidean_dist(s_star::Vector, s::Vector, w::Vector)

The (weigthed) Euclidean distance function, computed as

```math
ρ_{\text{Euclidean}}(x, y ; w) = (x-y)^{\transpose}\text{diag}(1/w^2)(x-y).$
```

Where ``w`` is the weighting matrix.
"""
function euclidean_dist(s_star::Vector, s::Vector, w::Vector)

  Δs =  (s_star-s)
  dist = Δs'*inv(diagm(w.^2))*Δs
  return sqrt(dist[1])

end


doc"""
    gaussian_kernel_dist(s_star::Vector, s::Vector, w::Vector)

The Gaussian kernel distance function.

```math
ρ_{\text{Gaussian}}(x, y ; \Sigma) = (x-y)^{\transpose}\Sigma^{-1}(x-y).
```

Where ``\Sigma`` is the covariance matrix.

"""
function gaussian_kernel_dist(s_star::Vector, s::Vector, Ω_inv::Array)

  Δs =  (s_star-s)
  dist = Δs'*Ω_inv*Δs
  return dist[1]

end


# add more distance functions here
