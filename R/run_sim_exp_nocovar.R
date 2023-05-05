#' Run simulation of models without covariates
#'
#' @param n_iter ...
#' @param d_params ...
#' @param fit_function ...
#' @param model ...
#' @param m_params ...
#'
#' @return ...
#' @export
#'
#' @examples
#' print("...")
#' 
run_sim_exp_nocovar <- function(
  n_iter, d_params, fit_function, model, m_params
) {
  # Simulate data
  d_mult <- sim_dat_mult_trials_exp_nocovar(n_iter = n_iter, params = d_params)
  # Run models
  multiple_fits <- fit_mult_exp_nocovar(
    list_dat_mult_trials = d_mult,
    fit_function = fit_function,
    model = model,
    m_params = m_params
  )
  # Obtain operating characteristics
  sim <- ocs_exp_nocovar(
    multiple_fits = multiple_fits,
    d_params = d_params,
    m_params = m_params
    )
  return(sim)
}