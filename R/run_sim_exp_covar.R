#' Run simulation of two-arm trials with an exponentially distributed time-to-event endpoint and one predictor of the intercurrent event
#'
#' @param n_iter Positive integer value, number of trials to be simulated.
#' @param d_params List of data parameters as used in `sim_dat_one_trial_exp_nocovar`.
#' @param m_params List of model parameters as used in `fit_single_exp_nocovar`.
#' @param seed Numeric value, seed for reproducibility.
#'
#' @return A list of length 3, containing objects call `ocs`, `d_params`, `m_params`, where `ocs` is a `tibble` containing averaged parameter estimates and operating characteristics, and `d_params` and `m_params` are the objects supplied to the function.
#' @export
#'
#' @seealso [run_sim_exp_nocovar()]
#'
#' @examples
#' d_params_covar <- list(
#'   n = 1000,        
#'   nt = 500,       
#'   prob_X1 = 0.4, 
#'   prob_ice_X1 = 0.5, 
#'   prob_ice_X0 = 0.2,
#'   fu_max = 336L,
#'   prop_cens = 0.15,       
#'   T0T_rate = 0.2,     
#'   T0N_rate = 0.2,     
#'   T1T_rate = 0.15,     
#'   T1N_rate = 0.1
#'  )
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
#'   warmup = 1500,
#'   cores = 2,
#'   open_progress = FALSE,
#'   show_messages = TRUE
#' )
#' \donttest{ 
#' dat_ocs <- run_sim_exp_covar(
#'   n_iter = 3, 
#'   d_params = d_params_covar, 
#'   m_params = m_params_covar, 
#'   seed = 12
#'   )
#' print(dat_ocs)
#' }
#' 
run_sim_exp_covar <- function(
    n_iter, d_params, m_params, seed
) {
  # Simulate data
  d_mult <- sim_dat_mult_trials_exp_covar(
    n_iter = n_iter, 
    params = d_params
  )
  # Run models
  multiple_fits <- fit_mult_exp_covar(
    dat_mult_trials = d_mult,
    params = m_params,
    seed = seed
  )
  # Obtain operating characteristics
  sim <- ocs_exp_covar(
    multiple_fits = multiple_fits,
    d_params = d_params,
    m_params = m_params
  )
  return(sim)
}