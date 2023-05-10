
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BPrinStratTTE

<!-- badges: start -->

[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Bayesian principal stratification for exponentially distributed
time-to-event endpoints.

## Scope

- The package contains functions to fit Bayesian principal
  stratification models and to perform clinical trial simulations in
  order to determine operating characteristics for given scenarios.
- Two-arm clinical trials are considered
  - with an intercurrent event that can only occur in the treated arm,
    e.g. antidrug antibody occurence in trials of biologics, and
  - that have an exponentially distributed time-to-event endpoint.
- Potential predictors of the intercurrent event can be taken into
  account.

## Installation

You can install the `BPrinStratTTE` package from GitHub with:

``` r
if (!require("remotes")) {install.packages("remotes")}
remotes::install_github("chstock/BPrinStratTTE")
```
