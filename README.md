# [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/SamuelWiqvist/abc/master) Approximate Bayesian Computation in Julia

This repository contains some Approximate Bayesian computation algorithms.

A toy example for each algorithm is also provided in the examples.

Algorithms:
* ABC rejection sampling (ABC-RS)
* ABC Markov chain Monte Carlo (ABC-MCMC)
* ABC population Monte Carlo (ABC-PMC)

Kernels:
* Uniform
* Gaussian

Distance functions:
* (Weighted) Euclidian distance

## How to use this module

This package is not added to `METADATA`. However, to install the package you can run: `Pkg.clone("https://github.com/SamuelWiqvist/ApproximateBayesianComputation.jl")`. 

To run the examples directly in your browser simply click on the binder link. However, launching the binder server might take a while (in some cases up to 20 minutes) since the environment has to be set up on the server.

## About this repository

This repository was originally created for the graduate course *Approximate Bayesian Computation* at Chalmers University of Technology.
