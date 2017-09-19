# pmadsim
pmadsim — Prospective Microarray Data Simulation. 

This is a fork and extension of the `madsim` R package. We have extended this method to allow for 
differential expression to increase over time. 

## installation

```{r}
install.packages("devtools")
devtools::install_github("3inar/pmadsim")
````

## simulation 
The `simulation` method recreates the simulation in our article.
```{r}
library(pmadsim)
simulation()
```
