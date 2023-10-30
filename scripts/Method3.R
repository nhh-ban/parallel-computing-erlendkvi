#### Parallel Computing, Assignment - BAN400 ####

## Method 3: Rewriting the MTweedieTests function

# Loading relevant packages
library(tidyverse)
library(tweedie)
library(tictoc)
library(doParallel)

# Creating cluster of cores
maxcores <- 8
cores <- min(maxcores, parallel::detectCores())
cl <- makeCluster(cores)
registerDoParallel(cl)

tic(paste0("Rewriting MTweedieTests, ", cores, " cores")) # Initiating timer

simTweedieTest <-  
  function(N){ 
    t.test( 
      rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 

# Rewriting the MTweedieTests 
MTweedieTests <- 
  function(N,M,sig) {
    p <- foreach(i = 1:M, 
                 .combine = c,
                 .export = 'simTweedieTest',
                 .packages = 'tweedie') %dopar% {
                   simTweedieTest(N)
                 }
    
    return(sum(p < sig) / M)
  }

df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 

for(i in 1:nrow(df)){ 
  df$share_reject[i] <-  
    MTweedieTests( 
      N=df$N[i], 
      M=df$M[i], 
      sig=.05) 
} 

toc(log = TRUE) # Ending timer
