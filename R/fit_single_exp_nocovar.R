#' Fit Bayesian principal stratification model for an exponentially distributed endpoint without consideration of predictors of the intercurrent event
#'
#' @param data ...
#' @param params ...
#' @param summarize_fit ...
#'
#' @return ...
#' @export
#'
#' @examples
#' \dontrun{
#' d_params_nocovar <- list(
#'   n = 500L,
#'   nt = 250L,
#'   prob_ice = 0.5,
#'   fu_max = 336L,
#'   T0T_rate = 0.2,
#'   T0N_rate = 0.2,
#'   T1T_rate = 0.15,
#'   T1N_rate = 0.1
#' )
#' dat_single_trial <- sim_dat_one_trial_exp_nocovar(
#'   n = d_params_nocovar[["n"]], 
#'   nt = d_params_nocovar[["nt"]],
#'   prob_ice = d_params_nocovar[["prob_ice"]],
#'   fu_max = d_params_nocovar[["fu_max"]],  
#'   T0T_rate = d_params_nocovar[["T0T_rate"]],
#'   T0N_rate = d_params_nocovar[["T0N_rate"]],
#'   T1T_rate = d_params_nocovar[["T1T_rate"]],
#'   T1N_rate = d_params_nocovar[["T1N_rate"]] 
#' )
#' m_params_nocovar <- list(
#'   tg = 48L,
#'   prior_piT = c(0.5, 0.5),
#'   prior_0N = c(1.5, 5),
#'   prior_1N = c(1.5, 5),
#'   prior_0T = c(1.5, 5),
#'   prior_1T = c(1.5, 5),
#'   t_grid =  seq(7, 7 * 48, 7) / 30,
#'   chains = 2L,
#'   n_iter = 3000L,
#'   burnin = 1500L,
#'   cores = 2L,
#'   open_progress = TRUE,
#'   show_messages = TRUE
#' )
#' fit_single <- fit_single_exp_nocovar(
#'   data = dat_single_trial,
#'   params = m_params_nocovar,
#'   summarize_fit = TRUE
#' )
#' print(fit_single)
#' }
fit_single_exp_nocovar <- function(data, params, summarize_fit = TRUE) {
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
  fit_stan <- rstan::sampling(
    object = stanmodels$m_exp_nocovar,
    data   = data_stan,
    iter   = params[["n_iter"]],
    warmup = params[["burnin"]],
    chains = params[["chains"]],
    cores  = params[["cores"]],
    open_progress = params[["open_progress"]],
    show_messages = params[["show_messages"]]
  )
  # for use with .stan files:
  # fit_stan <- rstan::stan(
  #  file   = model,
  #  data   = data_stan,
  #  iter   = params[["n_iter"]],
  #  warmup = params[["burnin"]],
  #  chains = params[["chains"]],
  #  cores  = params[["cores"]]
  #)
  fit_stan <- fit_stan %>% rstan::summary() %>% magrittr::extract2("summary")
  if(isTRUE(summarize_fit)) {
    patterns <- c("S_", "lp", "n_eff")
    fit_stan <- tibble::as_tibble(fit_stan, rownames="var") %>%
      dplyr::filter(!grepl(paste(patterns, collapse="|"), var)) %>%
      dplyr::select(!c("se_mean", "sd", "25%", "75%"))   
    }
  return(fit_stan)
}