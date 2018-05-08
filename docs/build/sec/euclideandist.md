
<a id='Weighted-Euclidean-distance-function-1'></a>

# Weighted Euclidean distance function


The (weighted) Euclidean distance function, computed as


$$
\rho_{\text{Euclidean}}(x, y ; w) = (x-y)^{\transpose}\text{diag}(1/w^2)(x-y).
$$


Where $w$ is the weighting matrix.

<a id='ApproximateBayesianComputation.euclidean_dist' href='#ApproximateBayesianComputation.euclidean_dist'>#</a>
**`ApproximateBayesianComputation.euclidean_dist`** &mdash; *Function*.



```
euclidean_dist(s_star::Vector, s::Vector, w::Vector)
```

The (weigthed) Euclidean distance function, computed as

$ ρ_{\text{Euclidean}}(x, y ; w) = (x-y)^{\transpose}\text{diag}(1/w^2)(x-y).$

Where $w$ is the weighting matrix.


<a target='_blank' href='https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl/blob/f39fb4d489dbf9adefa5fe467339f80e3aa7837c/src\distancefunctions.jl#L2' class='documenter-source'>source</a><br>

