dciR
====

A modification of the directional connectivity index calculation from Larsen et al. (2012). Essentially replaces [MatlabBGL](http://dgleich.github.com/matlab-bgl/) with [octave-networks-toolbox](https://github.com/aeolianine/octave-networks-toolbox). For convenience, Octave is called from R using [RcppOctave](http://cran.r-project.org/web/packages/RcppOctave/index.html).

Requires Octave and RcppOctave (verified to work with version 3.8.1 and 0.14.5 respectively)



## Installation
  ```R
  install.packages('devtools')  # package devtools needed
  devtools::install_github('jsta/dciR')
  ```
  
## Examples
   ```R
   #The example below reproduces figure 3 from Larsen et al. (2012)
   library(dciR)
   library(RcppOctave)
   
   #load test matricies####
   ma <- matrix(c(0,0,1,0,0,0,1,0,1,0,0,1,0,0,1,0,0,0,1,0,1,1,0,0,0),nrow=5,byrow=T)
   mb <- matrix(c(1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0),nrow=5,byrow=T)
   mc <- matrix(c(1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1),nrow=5,byrow=T)
   md <- matrix(c(1,0,0,0,1,1,0,1,0,1,0,0,1,0,0,1,0,0,0,1,1,0,0,0,1),nrow=5,byrow=T)
   
   dci(ma,1,1) 
   ```
   
## References 

**Larsen, L. G., Choi, J., Nungesser, M. K., & Harvey, J. W. (2012)**. Directional connectivity in hydrology and ecology. *Ecological applications*, **22**(8), 2204-2220.