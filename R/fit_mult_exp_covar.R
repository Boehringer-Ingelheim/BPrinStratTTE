#' Fit multiple models with predictors of the intercurrent event
#'
#' @param dat_mult_trials ...
#' @param params ...
#' @param seed ...
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
#'   n_iter = 2,
#'   params = d_params_covar 
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
#' fit_multiple <- fit_mult_exp_covar(
#'   dat_mult_trials = dat_mult_trials,
#'   params = m_params_covar,
#'   seed = 12
#' )
#' lapply(fit_multiple, dim)
#' head(fit_multiple[[1]])
#' }
#' 
fit_mult_exp_covar <- function(
    dat_mult_trials, 
    params, 
    seed = 23) {
  furrr::future_map(
    .x = dat_mult_trials,
    .f = fit_single_exp_covar,
    params = params,
    .options = furrr::furrr_options(seed = seed)
  )
}