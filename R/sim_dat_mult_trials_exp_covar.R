#' Simulate data from multiple 2-arm trials with predictors of the intercurrent event
#'
#' @param n_iter ...
#' @param params ...
#'
#' @return ...
#' @export
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
#' dat_mult_trials <- sim_dat_mult_trials_exp_covar(
#'   n_iter = 3,
#'   params = d_params_covar 
#' )
#' lapply(dat_mult_trials, dim)
#' head(dat_mult_trials[[1]]) 
#' 
sim_dat_mult_trials_exp_covar <- function(n_iter, params) {
  replicate(
    n_iter,
    sim_dat_one_trial_exp_covar(
      n           = params[["n"]],        
      nt          = params[["nt"]],
      prob_X1     = params[["prob_X1"]], 
      prob_ice_X1 = params[["prob_ice_X1"]], 
      prob_ice_X0 = params[["prob_ice_X0"]],
      fu_max      = params[["fu_max"]],       
      T0T_rate    = params[["T0T_rate"]],     
      T0N_rate    = params[["T0N_rate"]],     
      T1T_rate    = params[["T1T_rate"]],     
      T1N_rate    = params[["T1N_rate"]] 
    ),
    simplify = F
  ) %>%
    lapply(FUN = function(x) x[!(names(x) %in% c("PAT_ID","T0N","T0T","T1N","T1T"))])
}