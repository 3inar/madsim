pmadsim <-
function(mdata = NULL, n = 10000, ratio = 0,
         fparams = data.frame(m1=7, m2=7, shape2=4, lb=4, ub=14, pde=0.02, sym=0.5),
         dparams = data.frame(lambda1=0.13, lambda2=2, muminde=1.0, sdde=0.5),
         sdn=0.4, rseed=50, time_decay=F, stratified=F, min_decay_weight=0.05) {

    # set.seed(rseed);
    m1 <- fparams$m1;
    m2 <- fparams$m2;
    m <- m1+m2+1;  #first column will be reference if ratio=1
    n1 <- length(mdata);
    if (n<100) n <- 100;

    if (n1>100) {   # mdata is not NULL
        if (n == 0) { n <- n1; x2 <- mdata; }
        else {
                  if (n < n1) { x2 <- sample(mdata, n, replace = FALSE); }
                  else { x2 <- sample(mdata, n, replace = TRUE); }
           }
    } else {        # mdata is NULL
           x <- rbeta(n, 2, fparams$shape2);
           x2 <- fparams$lb + (fparams$ub*x);
    }

    if (time_decay) {
      followup <- runif(m1+m2)
      decay_weight <- 1-followup[-(1:m1)]
      decay_weight[decay_weight < min_decay_weight] <- min_decay_weight
    } else {
      followup <- rep(NA, m1+m2)
      decay_weight <- rep(1, m2)
    }

    if (stratified) {
      stratum <- rbinom(m1+m2, prob = .5, size = 1)
      stratum_effect <- .5^stratum[-(1:m1)]
    } else {
      stratum <- rep(NA, m1+m2)
      stratum_effect <- rep(1, m2)
    }


    xdat <- matrix(c(rep(0,n*m)), ncol = m);
    xid <- matrix(c(rep(0,n)), ncol = 1);
    for (i in 1:n) {
        alpha <- dparams$lambda1*exp(-dparams$lambda1*x2[i]);
        xi_val <- runif(m, min = (1-alpha)*x2[i], max = (1+alpha)*x2[i]);
        if (sample(1:1000,1) > (1000*fparams$pde)) { # case of non DE gene
           xdat[i,] <- xi_val;
        } else { # case of DE gene

               xi1 <- xi_val[1:(m1+1)];
               mude <- dparams$muminde + rexp(1, dparams$lambda2);
               if (sample(1:1000,1) > (1000*fparams$sym)) { # up regulated gene
                  xi2 <- xi_val[(m1+2):m] + rnorm(m2, mean = mude, sd = dparams$sdde)*decay_weight*stratum_effect;
                  xid[i] <- 1;
               } else { # down regulated gene
                  xi2 <- xi_val[(m1+2):m] - rnorm(m2, mean = mude, sd = dparams$sdde)*decay_weight*stratum_effect;
                  xid[i] <- -1;
               }
               xdat[i,] <- c(xi1,xi2);
        }
    }
    cont <- paste("cont", 1:m1, sep = "");
    test <- paste("test", 1:m2, sep = "");
    colnames(xdat) <- c("V1", cont, test);

    xsd <- sd(xdat[,1]);
    if (sdn>0) {
       ndat <- matrix(c(rnorm(n*m, mean = 0, sd = sdn)), ncol = m);
       xdat <- xdat + ndat;
    }
    xdata <- matrix(c(rep(0,n*(m-1))), ncol = (m-1));

    if (ratio) {  # ratio expression values
       xdata <- xdat[,2:m] - xdat[,1];
    } else {    # absolute expression values
           xdata <- xdat[,2:m];
    }
    list(xdata = xdata, xid = xid, xsd = xsd, followup=followup, stratum=stratum)
}
