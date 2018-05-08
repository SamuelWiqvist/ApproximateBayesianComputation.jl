# Weighted Euclidean distance function

The (weighted) Euclidean distance function, computed as

$\rho_{\text{Euclidean}}(x, y ; w) = (x-y)^{\transpose}\text{diag}(1/w^2)(x-y).$

Where $w$ is the weighting matrix.

```@docs
ApproximateBayesianComputation.euclidean_dist
```
