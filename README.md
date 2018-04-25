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

The module can be download as any other repository. To add the module to your local `LOAD_PATH` variable run `push!(LOAD_PATH, "path_to_module/abc-master/src")`

This line can also be added to the file  `~/.juliarc.jl` to automatically include the module each time Julia starts.

To run the examples directly in your browser simply click on the binder link. However, launching the binder server might take a while (in some cases up to 20 minutes) since the environment has to be set up on the server.

## About this repository

This repository was originally created for the graduate course *Approximate Bayesian Computation* at Chalmers University of Technology.
