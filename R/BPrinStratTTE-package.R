#' The 'BPrinStratTTE' package.
#'
#' @description Bayesian principal stratification for clincial trials with (exponentially distributed) time-to-event endpoints, with or without consideration of predictors of the intercurrent event
#'
#' @docType package
#' @name BPrinStratTTE-package
#' @aliases BPrinStratTTE
#' @useDynLib BPrinStratTTE, .registration = TRUE
#' @import methods
#' @import Rcpp
#' @importFrom rstan sampling
#'
#' @references
#' Stan Development Team (2022). RStan: the R interface to Stan. R package version 2.21.5. https://mc-stan.org
#'
NULL

## usethis namespace: start
#' @importFrom stats pexp
#' @importFrom stats rexp
#' @importFrom stats runif
#' @importFrom dplyr select
#' @importFrom dplyr filter
#' @importFrom dplyr mutate
#' @importFrom purrr map
#' @importFrom furrr future_map
#' @importFrom magrittr %>%
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
#' @importFrom stringr str_pad
## usethis namespace: end
NULL
