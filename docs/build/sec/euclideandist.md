
<a id='Weighted-Euclidean-distance-function-1'></a>

# Weighted Euclidean distance function

<a id='ApproximateBayesianComputation.euclidean_dist' href='#ApproximateBayesianComputation.euclidean_dist'>#</a>
**`ApproximateBayesianComputation.euclidean_dist`** &mdash; *Function*.



```
euclidean_dist(s_star::Vector, s::Vector, w::Vector)
```

The (weigthed) Euclidean distance function, computed as

$$
ρ_{\text{Euclidean}}(x, y ; w) = (x-y)^{T}\text{diag}(1/w^2)(x-y).
$$

Where w is the weighting matrix.

