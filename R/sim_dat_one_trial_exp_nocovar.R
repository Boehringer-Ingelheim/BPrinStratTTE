#' Simulate data from a single 2-arm trial without predictors of intercurrent events
#'
#' @param n Number of subjects in the trial
#' @param nt Number of treated subjects
#' @param prob_ice Probability of an intercurrent event
#' @param fu_max Maximum follow-up time in days (administrative censoring is assumed afterwards)
#' @param T0T_rate Monthly event rate in control subjects that would develop the intercurrent event if given treatment
#' @param T0N_rate Monthly event rate in control subjects that never develop the intercurrent event 
#' @param T1T_rate Monthly event rate in treated subjects that develop the intercurrent event
#' @param T1N_rate Monthly event rate in treated subjects that never develop the intercurrent event
#'
#' @return A `tibble()`containing an analysis dataset
#' @export
#'
#' @examples
#' print("...")
sim_dat_one_trial_exp_nocovar <- function(
  n,             # number of patients
  nt,            # number of treated patients
  prob_ice,      # prob ICE 
  fu_max,        # maximum follow-up (days)
  T0T_rate,      # monthly event rate in controls TD
  T0N_rate,      # monthly event rate in controls ND
  T1T_rate,      # monthly event rate in treated TD
  T1N_rate       # monthly event rate in treated ND
) {
  # baseline data
  Z  <- sample(c(rep(0L, n - nt), rep(1L, nt)))
  # intercurrent event data
  G <- sample(c(0L, 1L), size = n, prob = c(1 - prob_ice, prob_ice), replace = T)
  S <- G
  S[Z==0L] <- 0L
  # time to event endpoint data by principal stratum
  cens <- runif(n = n, min = 1, max = fu_max)
  T0T <- rexp(n = n, rate = T0T_rate) * 30
  T0N <- rexp(n = n, rate = T0N_rate) * 30
  T1T <- rexp(n = n, rate = T1T_rate) * 30
  T1N <- rexp(n = n, rate = T1N_rate) * 30
  E0T <- as.integer(T0T <= cens)
  E0N <- as.integer(T0N <= cens)
  E1T <- as.integer(T1T <= cens)
  E1N <- as.integer(T1N <= cens)
  EVENT <- NULL
  EVENT[Z==0 & G==0] <- E0N[Z==0 & G==0]
  EVENT[Z==0 & G==1] <- E0T[Z==0 & G==1]
  EVENT[Z==1 & G==0] <- E1N[Z==1 & G==0]
  EVENT[Z==1 & G==1] <- E1T[Z==1 & G==1]
  TIME <- NULL
  TIME[EVENT==0] <- round(cens[EVENT==0])
  TIME[EVENT==1 & Z==0 & G==0] <- round(T0N[EVENT==1 & Z==0 & G==0])
  TIME[EVENT==1 & Z==0 & G==1] <- round(T0T[EVENT==1 & Z==0 & G==1])
  TIME[EVENT==1 & Z==1 & G==0] <- round(T1N[EVENT==1 & Z==1 & G==0])
  TIME[EVENT==1 & Z==1 & G==1] <- round(T1T[EVENT==1 & Z==1 & G==1])
  TIME <- as.integer(TIME)
  return(
    tibble(
      PAT_ID = str_pad(1:n, nchar(n), pad = "0"),
      Z = Z,
      G = G,
      S = S,
      TIME = TIME,
      EVENT = EVENT,
      T0N = T0N,
      T0T = T0T,
      T1N = T1N,
      T1T = T1T
    )
  ) 
}
