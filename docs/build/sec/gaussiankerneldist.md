
<a id='Gaussian-kernel-distance-function-1'></a>

# Gaussian kernel distance function

<a id='ApproximateBayesianComputation.gaussian_kernel_dist' href='#ApproximateBayesianComputation.gaussian_kernel_dist'>#</a>
**`ApproximateBayesianComputation.gaussian_kernel_dist`** &mdash; *Function*.



```
gaussian_kernel_dist(s_star::Vector, s::Vector, w::Vector)
```

The Gaussian kernel distance function.

$ρ_{\text{Gaussian}}(x, y ; Σ) = (x-y)^{\transpose}\Sigma^{-1}(x-y).$

Where $Σ$ is the covariance matrix.


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/f39fb4d489dbf9adefa5fe467339f80e3aa7837c/src\distancefunctions.jl#L20' class='documenter-source'>source</a><br>

