#' Determine operating characteristics of multiple models
#'
#' @param multiple_fits 
#' @param d_params 
#' @param m_params 
#'
#' @return ...
#' @export
#'
#' @examples
#' print("...")
ocs_exp_nocovar <- function(multiple_fits, d_params, m_params) {
  # obtain names of parameters to evaluate
  var <- multiple_fits[[1]] %>% select(var)
  # aggregate (numeric variables)
  ocs <- map(
    .x = multiple_fits,
    .f = ~ summarize_trial_results_nocovar(
      x = .x,
      d_params = d_params,
      m_params = m_params
    )
  ) %>%
    map(~ select(.x, -var)) %>%
    map(as.matrix) %>%
    simplify2array() %>%
    apply(c(1, 2), mean)
  # add names of parameters
  ocs <- as_tibble(cbind(var = var, ocs))
  # return ocs and data/model parameters
  return(list(
    "ocs" = ocs, 
    "d_params" = unlist(d_params),
    "m_params" = unlist(m_params)
  ))
}