#' Fit multiple models without covariates
#'
#' @param list_dfs ...
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
fit_mult_exp_nocovar <- function(list_dfs, fit_function, model, m_params, seed=23) {
  future_map(
    .x = list_dfs,
    .f = fit_function,
    model = model,
    params = m_params,
    .options = furrr_options(seed = seed)
  )
}