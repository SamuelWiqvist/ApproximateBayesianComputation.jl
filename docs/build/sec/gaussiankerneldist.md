
<a id='Gaussian-kernel-distance-function-1'></a>

# Gaussian kernel distance function

<a id='ApproximateBayesianComputation.gaussian_kernel_dist' href='#ApproximateBayesianComputation.gaussian_kernel_dist'>#</a>
**`ApproximateBayesianComputation.gaussian_kernel_dist`** &mdash; *Function*.



```
gaussian_kernel_dist(s_star::Vector, s::Vector, w::Vector)
```

The Gaussian kernel distance function, computed as

$$
ρ_{\text{Gaussian}}(x, y ; \Sigma) = (x-y)^{T}\Sigma^{-1}(x-y).
$$

Where Σ is the covariance matrix.

