#' Fit single model to data from a two-arm trial with an exponentially distributed time-to-event endpoint and one predictor of the intercurrent event
#'
#' @param data ...
#' @param params ...
#' @param summarize_fit ...
#'
#' @return ...
#' @export
#'
#' @seealso [fit_single_exp_nocovar()]
#'
#' @examples
#' d_params_covar <- list(
#'   n = 1000,        
#'   nt = 500,       
#'   prob_X1 = 0.4, 
#'   prob_ice_X1 = 0.5, 
#'   prob_ice_X0 = 0.2,
#'   fu_max = 48*7,       
#'   T0T_rate = 0.2,     
#'   T0N_rate = 0.2,     
#'   T1T_rate = 0.15,     
#'   T1N_rate = 0.1
#'  )
#' dat_single_trial <- sim_dat_one_trial_exp_covar(
#'   n = d_params_covar[["n"]], 
#'   nt = d_params_covar[["nt"]],
#'   prob_X1 = d_params_covar[["prob_X1"]],
#'   prob_ice_X1 = d_params_covar[["prob_ice_X1"]],
#'   prob_ice_X0 = d_params_covar[["prob_ice_X0"]],
#'   fu_max = d_params_covar[["fu_max"]],  
#'   T0T_rate = d_params_covar[["T0T_rate"]],
#'   T0N_rate = d_params_covar[["T0N_rate"]],
#'   T1T_rate = d_params_covar[["T1T_rate"]],
#'   T1N_rate = d_params_covar[["T1N_rate"]] 
#' )
#' m_params_covar <- list(
#'   tg = 48,
#'   p = 2, 
#'   prior_delta = matrix(
#'     c(0, 5, 0, 5),
#'     nrow = 2, byrow = TRUE),
#'   prior_0N = c(1.5, 5),
#'   prior_1N = c(1.5, 5),
#'   prior_0T = c(1.5, 5),
#'   prior_1T = c(1.5, 5),
#'   t_grid =  seq(7, 7 * 48, 7) / 30,
#'   chains = 2,
#'   n_iter = 3000,
#'   burnin = 1500,
#'   cores = 2,
#'   open_progress = FALSE,
#'   show_messages = TRUE   
#' )
#' \dontrun{
#' fit_single <- fit_single_exp_covar(
#'   data = dat_single_trial,
#'   params = m_params_covar,
#'   summarize_fit = TRUE
#' )
#' print(fit_single) 
#' }
fit_single_exp_covar <- function(data, params, summarize_fit = TRUE) {
  # input data for model
  data_stan <- list(
    n = nrow(data),
    nt = sum(data$Z==1),
    p = params[["p"]], 
    tg = params[["tg"]],
    Z = data$Z,
    S = data$S,
    S_trt = data$S[data$Z==1],
    TIME = data$TIME/30,
    EVENT = data$EVENT,
    X = matrix(c(rep(1,nrow(data)), data$X), nrow = nrow(data)),
    X_trt = matrix(c(rep(1,sum(data$Z==1)), data$X[data$Z==1]), nrow = sum(data$Z==1)),
    prior_delta = params[["prior_delta"]],
    prior_0N = params[["prior_0N"]],
    prior_1N = params[["prior_1N"]],
    prior_0T = params[["prior_0T"]],
    prior_1T = params[["prior_1T"]],
    t_grid = params[["t_grid"]]
  )
  # fit model
  fit_stan <- rstan::sampling(
    object = stanmodels$m_exp_covar,
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
  #   file   = model,
  #   data   = data_stan,
  #   iter   = params[["n_iter"]],
  #   warmup = params[["burnin"]],
  #   chains = params[["chains"]],
  #   cores  = params[["cores"]]
  # )
  fit_stan <- fit_stan %>% rstan::summary() %>% magrittr::extract2("summary")
  if(isTRUE(summarize_fit)) {
    patterns <- c("S_", "lp", "n_eff")
    fit_stan <- tibble::as_tibble(fit_stan, rownames="var") %>%
      dplyr::filter(!grepl(paste(patterns, collapse="|"), var)) %>%
      dplyr::select(!c("se_mean", "sd", "25%", "75%"))   
  }
  return(fit_stan)
}