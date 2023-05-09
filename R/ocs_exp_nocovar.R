#' Determine operating characteristics of multiple models
#'
#' @param multiple_fits ...
#' @param d_params ...
#' @param m_params ...
#'
#' @return ...
#' @export
#'
#' @examples
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
#' dat_mult_trials <- sim_dat_mult_trials_exp_nocovar(
#'   n_iter = 2,
#'   params = d_params_nocovar 
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
#'   cores = 2L
#' )
#' fit_multiple <- fit_mult_exp_nocovar(
#'   dat_mult_trials = dat_mult_trials,
#'   params = m_params_nocovar,
#'   seed = 12
#' )
#' list_ocs <- ocs_exp_nocovar(
#'   multiple_fits = fit_multiple, 
#'   d_params = d_params_nocovar, 
#'   m_params = m_params_nocovar
#' )
#' print(list_ocs)
ocs_exp_nocovar <- function(multiple_fits, d_params, m_params) {
  # obtain names of parameters to evaluate
  var <- multiple_fits[[1]] %>% select(var)
  # aggregate (numeric variables)
  ocs <- map(
    .x = multiple_fits,
    .f = ~ true_vals_exp_nocovar(
      x = .x,
      d_params = d_params,
      m_params = m_params
    )
  ) %>%
    map(~ dplyr::select(.x, -var)) %>%
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