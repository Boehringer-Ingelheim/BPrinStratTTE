#' Fit multiple models without covariates
#'
#' @param list_dat_mult_trials ...
#' @param fit_function ...
#' @param model ...
#' @param m_params ...
#' @param seed ...
#'
#' @return ...
#' @export
#'
#' @examples
#' print("...")
#' 
fit_mult_exp_nocovar <- function(list_dat_mult_trials, fit_function, model, m_params, seed=23) {
  furrr::future_map(
    .x = list_dat_mult_trials,
    .f = fit_function,
    model = model,
    params = m_params,
    .options = furrr::furrr_options(seed = seed)
  )
}