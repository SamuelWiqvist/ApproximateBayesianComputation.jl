
<a id='Gaussian-kernel-1'></a>

# Gaussian kernel

<a id='ApproximateBayesianComputation.gaussian_kernel' href='#ApproximateBayesianComputation.gaussian_kernel'>#</a>
**`ApproximateBayesianComputation.gaussian_kernel`** &mdash; *Function*.



```
gaussian_kernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)
```

The Gaussian kernel function follows

$K^{\text{Gaussian}}_{\epsilon}(x,y) \propto \exp(-\rho_{\text{Gaussian}}(x,y)/2\epsilon^2).$


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/f39fb4d489dbf9adefa5fe467339f80e3aa7837c/src\kernels.jl#L25' class='documenter-source'>source</a><br>

