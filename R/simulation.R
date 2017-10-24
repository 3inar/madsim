simulation <- function(n_case=33, n_control=55, lambda2=4, stratified=F) {
  data(pooled)
  tot <- n_case + n_control
  fparams = data.frame(m1=n_control+tot,m2=n_case, shape2=4, lb=4,ub=14,pde=0.01,sym=0.5)
  dparams = data.frame(lambda1=0.13, lambda2=lambda2, muminde=0.1, sdde=0.1)
  dat <- pmadsim(mdata=pooled, fparams=fparams, stratified=stratified, dparams=dparams, n=10000, time_decay = T, ratio = 0, sdn=0.15)

  # emulates the fact that we have separate controls for all samples
  expression <- t(dat$xdata[, (tot+1):(2*tot)]) - t(dat$xdata[, 1:tot])
  differential <- dat$xid[,1]
  followup <- dat$followup[(tot+1):(2*tot)]
  status <- as.factor(c(rep("control", n_control), rep("case", n_case)))
  stratum <- dat$stratum[(tot+1):(2*tot)]

  return(list(expression=expression, stratum=stratum, differential=differential, followup=followup, status=status))
}


# d <- simulation(stratified = T, n_case = 500, n_control = 500, lambda2=2)
# differential <- d$differential
# expression <- d$expression
# followup <- d$followup
# status <- d$status
# stratum <- d$stratum
#
# diff <- which(differential != 0)
#
# gene <- sample(diff, 1)
# # gene <- 333
#
# dframe <- data.frame(expression=expression[, gene], followup, status=as.factor(status), stratum=as.factor(stratum))
#
# library(ggplot2)
#
#
# plot(expression~followup, data=dframe, col=status, pch=20, ylim=c(-1.5, 1.5))
# # abline(h=mean(expression[status=="case", gene]))
#
# selector <- status=="case" & stratum==1
# abline(lm(expression[selector, gene]~followup[selector]), col="grey")
# selector <- status=="case" & stratum==0
# abline(lm(expression[status=="case", gene]~followup[status=="case"]))
#
# #abline(lm(expression[status=="control", gene]~followup[status=="control"]), col="red")
# # abline(h=mean(expression[status=="control", gene]), col="red")
