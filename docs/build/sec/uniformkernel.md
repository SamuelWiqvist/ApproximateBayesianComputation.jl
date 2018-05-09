
<a id='Uniform-kernel-1'></a>

# Uniform kernel

<a id='ApproximateBayesianComputation.uniform_kernel' href='#ApproximateBayesianComputation.uniform_kernel'>#</a>
**`ApproximateBayesianComputation.uniform_kernel`** &mdash; *Function*.



```
uniform_kernel(s_star::Vector, s::Vector, ϵ::Real, ρ::Function)
```

The Uniform kernel function follows

$$
K^{\text{Uniform}}_{\epsilon}(\rho(x,y)) = \begin{cases}
        1, \text{if}, \rho(x,y) \le \epsilon,
        \\
        0, \text{otherwise}.
        \end{cases}
$$

Where ϵ is the threshold and ρ the distance function.

