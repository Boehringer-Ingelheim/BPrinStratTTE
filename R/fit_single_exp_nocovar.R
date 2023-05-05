#' Fit Bayesian principal stratification model for an exponentially distributed endpoint without consideration of predictors of the intercurrent event
#'
#' @param data ...
#' @param model ...
#' @param params ...
#'
#' @return ...
#' @export
#'
#' @examples
#' print("...")
#' 
fit_single_exp_nocovar <- function(data, model, params) {
  # input data for model
  data_stan <- list(
    n = nrow(data),
    tg = params[["tg"]],
    Z = data$Z,
    S = data$S,
    TIME = data$TIME/30,
    EVENT = data$EVENT,
    prior_piT = params[["prior_piT"]],
    prior_0N = params[["prior_0N"]],
    prior_1N = params[["prior_1N"]],
    prior_0T = params[["prior_0T"]],
    prior_1T = params[["prior_1T"]],
    t_grid = params[["t_grid"]]
  )
  # fit model
  fit_stan <- rstan::stan(
    file   = model,
    data   = data_stan,
    iter   = params[["n_iter"]],
    warmup = params[["burnin"]],
    chains = params[["chains"]],
    cores  = params[["cores"]]
  )
  fit_stan <- summary(fit_stan) %>% magrittr::extract2("summary")
  patterns <- c("S_", "lp", "n_eff")
  fit_stan <- as_tibble(fit_stan, rownames="var") %>%
    filter(!grepl(paste(patterns, collapse="|"), var)) %>%
    select(!c("se_mean", "sd", "25%", "75%"))
}