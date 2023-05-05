#' Simulate data from multiple 2-arm trials without predictors of intercurrent events
#'
#' @param n_iter ...
#' @param params ...
#'
#' @return ...
#' @export
#'
#' @examples
#' print("...")
#' 
sim_dat_mult_trials_exp_nocovar <- function(n_iter, params) {
  replicate(
    n_iter,
    sim_dat_one_trial_exp_nocovar(
      n = params[["n"]],
      nt = params[["nt"]],
      prob_ice = params[["prob_ice"]],
      fu_max = params[["fu_max"]],
      T0T_rate = params[["T0T_rate"]],
      T0N_rate = params[["T0N_rate"]],
      T1T_rate = params[["T1T_rate"]],
      T1N_rate = params[["T1N_rate"]]
    ),
    simplify = F
  ) %>%
    lapply(FUN = function(x) x[!(names(x) %in% c("PAT_ID","T0N","T0T","T1N","T1T"))])
}