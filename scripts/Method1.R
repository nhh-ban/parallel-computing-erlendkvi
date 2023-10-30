#### Parallel Computing, Assignment - BAN400 ####

## Method 1: The same method as in the original assignment

# Loading relevant packages
library(tidyverse)
library(tweedie)
library(tictoc)
library(doParallel)

# Copying the solution, but including elements from the 'tictoc' package

tic("Regular loop") # Initiating timer

simTweedieTest <-  
  function(N){ 
    t.test( 
      rtweedie(N, mu=10000, phi=100, power=1.9), 
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

for(i in 1:nrow(df)){ 
  df$share_reject[i] <-  
    MTweedieTests( 
      N=df$N[i], 
      M=df$M[i], 
      sig=.05) 
} 

toc(log = TRUE) # Ending timer

# Printing the results/log
printTicTocLog <-
  function() {
    tic.log() %>%
      unlist %>%
      tibble(logvals = .) %>%
      separate(logvals,
               sep = ":",
               into = c("Function type", "log")) %>%
      mutate(log = str_trim(log)) %>%
      separate(log,
               sep = " ",
               into = c("Seconds"),
               extra = "drop")
  }

printTicTocLog() %>%
  knitr::kable()
