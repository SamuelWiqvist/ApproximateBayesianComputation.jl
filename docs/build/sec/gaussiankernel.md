
<a id='Gaussian-kernel-1'></a>

# Gaussian kernel

<a id='ApproximateBayesianComputation.gaussian_kernel' href='#ApproximateBayesianComputation.gaussian_kernel'>#</a>
**`ApproximateBayesianComputation.gaussian_kernel`** &mdash; *Function*.



```
gaussian_kernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)
```

The Gaussian kernel function follows

$$
K^{\text{Gaussian}}_{\epsilon}(x,y) \propto \exp(-\rho(x,y)/2\epsilon^2).
$$

Where ϵ is the threshold and ρ the distance function.

The distance function ρ can be set to `gaussian_kernel_dist` where the summary statistics are weigthed according to a covariance matrix. But other distance functions can also be used.

