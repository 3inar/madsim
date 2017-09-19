\name{simulation}
\alias{simulation}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
 Simulation used in our article [TODO reference].
}
\description{
This method generates a data set with the parameters we used in [TODO].
}
\usage{
simulation()
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n_case}{
    number of cases to simulate
  }
  \item{n_control}{
    number of controls to simulate
  }
}
\value{
A list containing the following values
\item{expression}{Gene expression matrix of simulated fold change values. Observations in rows, genes in columns}
\item{differential}{Vector describing which genes are truly differentially expressed. Zero indicates no DE, -1 indicates down-regulation, 1 indicates up-regulation.}
\item{followup}{Followup time for each observation. A number in [0, 1].}
\item{status}{Vector denoting case--control status for each observation.}
}
\references{
%% ~put references to the literature/web site here ~
[TODO ref our article]
}

\seealso{
\code{\link{pmadsim}}
}
\examples{
d <- simulation()
differential <- d$differential
expression <- d$expression
followup <- d$followup
status <- d$status

diff <- which(differential != 0)

gene <- sample(diff, 1)
plot(followup, expression[, gene], col=status, pch=20, ylim=c(-1.5, 1.5))
abline(lm(expression[status=="case", gene]~followup[status=="case"]))
abline(lm(expression[status=="control", gene]~followup[status=="control"]), col="red")
}
