
<a id='Uniform-kernel-1'></a>

# Uniform kernel

<a id='ApproximateBayesianComputation.uniform_kernel' href='#ApproximateBayesianComputation.uniform_kernel'>#</a>
**`ApproximateBayesianComputation.uniform_kernel`** &mdash; *Function*.



```
uniform_kernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)
```

The Uniform kernel function follows

`` K^{\text{Uniform}}_{\epsilon}(\rho(x,y)) = \begin{cases}         1, \text{if}, \rho(x,y) \le \epsilon,         \
        0, \text{otherwise}.         \end{cases} ``


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/f39fb4d489dbf9adefa5fe467339f80e3aa7837c/src\kernels.jl#L1' class='documenter-source'>source</a><br>

