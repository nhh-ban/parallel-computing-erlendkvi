#### Parallel Computing, Assignment - BAN400 ####

## Method 2: Parallel computing on lines 29-35 in the original 
## assignment solution.

# Loading relevant packages
library(tidyverse)
library(tweedie)
library(tictoc)
library(doParallel)

simTweedieTest <-  
  function(N){ 
    t.test( 
      tweedie::rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 

MTweedieTests <-  
  function(N,M,sig){ 
    sum(replicate(M,simTweedieTest(N)) < sig)/M 
  } 

df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 

# Re-written part to implement parallel computing:
maxcores <- 8
cores <- min(parallel::detectCores(), maxcores)

cl <- makeCluster(cores)

registerDoParallel(cl)

df$share_reject <- 
  foreach(i = 1:nrow(df),
          .combine = c,
          .packages = 'tweedie') %dopar% {
            MTweedieTests( 
              N=df$N[i], 
              M=df$M[i], 
              sig=.05
            )
          }

stopCluster(cl)