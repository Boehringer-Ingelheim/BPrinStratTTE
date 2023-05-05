#' Summarize single fits of a model for an exponentially distributed endpoint without consideration of predictors of the intercurrent event
#'
#' @param x ...
#' @param d_params ...
#' @param m_params ...
#'
#' @return ...
#' @export
#'
#' @examples
#' print("...")
#' 
summarize_fit_exp_nocovar <- function(x, d_params, m_params) {
  # use model summary
  patterns <- c("S_", "lp", "n_eff")
  y <- as_tibble(x) %>% filter(!grepl(paste(patterns, collapse="|"), var))
  # add new variables
  y <- y %>% mutate(
    true_val = NA, diff_mean = NA, diff_median = NA, 
    coverage = NA, int_excl1 = NA, int_excl0 = NA,
    rhat_check = NA) 
  # add true proportion of patients with ICE
  y <- y %>% mutate(
    true_val = ifelse(var=="pi_T", d_params[["prob_ice"]], true_val),
  )
  # add true hazard rate and hazard ratios
  y <- y %>% mutate(
    true_val = ifelse(var=="lambda_0N", d_params[["T0N_rate"]], true_val),
    true_val = ifelse(var=="lambda_1N", d_params[["T1N_rate"]], true_val),
    true_val = ifelse(var=="lambda_0T", d_params[["T0T_rate"]], true_val),
    true_val = ifelse(var=="lambda_1T", d_params[["T1T_rate"]], true_val),
    true_val = ifelse(var=="hr_N", d_params[["T1N_rate"]]/d_params[["T0N_rate"]], 
                      true_val),
    true_val = ifelse(var=="hr_T", d_params[["T1T_rate"]]/d_params[["T0T_rate"]], 
                      true_val)
  )
  # add RMSTs and differences in RMSTs
  t_grid <- m_params[["t_grid"]]
  S_0n <- 1-pexp(t_grid, d_params[["T0N_rate"]])
  S_1n <- 1-pexp(t_grid, d_params[["T1N_rate"]])
  S_0c <- 1-pexp(t_grid, d_params[["T0T_rate"]])
  S_1c <- 1-pexp(t_grid, d_params[["T1T_rate"]])
  rmst_0n <- rmst_1n <- rmst_0c <- rmst_1c <- 0
  for (j in 2:length(t_grid)) {
    rmst_0n <- rmst_0n + ((S_0n[j-1]+S_0n[j])/2*(t_grid[j]-t_grid[j-1]))
    rmst_1n <- rmst_1n + ((S_1n[j-1]+S_1n[j])/2*(t_grid[j]-t_grid[j-1]))
    rmst_0c <- rmst_0c + ((S_0c[j-1]+S_0c[j])/2*(t_grid[j]-t_grid[j-1]))
    rmst_1c <- rmst_1c + ((S_1c[j-1]+S_1c[j])/2*(t_grid[j]-t_grid[j-1]))
  }
  d_rmst_n <- rmst_1n - rmst_0n
  d_rmst_c <- rmst_1c - rmst_0c
  y <- y %>% mutate(
    true_val = ifelse(var=="rmst_N", d_rmst_n, true_val),
    true_val = ifelse(var=="rmst_T", d_rmst_c, true_val),
    true_val = ifelse(var=="rmst_0N", rmst_0n, true_val),
    true_val = ifelse(var=="rmst_1N", rmst_1n, true_val),
    true_val = ifelse(var=="rmst_0T", rmst_0c, true_val),
    true_val = ifelse(var=="rmst_1T", rmst_1c, true_val)
  )
  # add comparisons to true values and checks
  y <- y %>% mutate(
    diff_mean = mean - true_val,
    diff_median = `50%` - true_val,
    coverage = ifelse(true_val >=`2.5%` & true_val <= `97.5%`, 1, 0),
    int_excl1= ifelse(1 <=`2.5%` | 1 >= `97.5%`, 1, 0),
    int_excl0= ifelse(0 <=`2.5%` | 0 >= `97.5%`, 1, 0),
    rhat_check = ifelse(Rhat >=0.98 & Rhat <= 1.02, 1, 0),
  )
  # return summary table
  return(y)
}