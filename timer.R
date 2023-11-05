#### Parallel Computing, Assignment - BAN400 ####

# Timing method 1
tic("Method 1: Regular loop")
source("scripts/Method1.R")
toc(log = TRUE)

# Timing method 2
tic("Method 2: Parallel loop")
source("scripts/Method2.R")
toc(log = TRUE)

# Timing method 3
tic("Method 3: Rewriting MTweedieTests")
source("scripts/Method3.R")
toc(log = TRUE)

# I get slightly varied results, but method 2 seems to be consistently slower
# than 1 and 3. This is a pretty strange result, because utilizing more cores
# should make the operations faster. However, my computer is somewhat old, so
# so that could be a part of the explanation. Method 3, however, is (in most
# cases) fastest, often by more than 10 seconds. 

