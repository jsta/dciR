dciR
====

A modification of the directional connectivity index calculation from Larsen et al. (2012). Essentially replaces [MatlabBGL](http://dgleich.github.com/matlab-bgl/) with [RBGL](http://www.bioconductor.org/packages/release/bioc/html/RBGL.html). For convenience, Octave is called from R using [RcppOctave](http://cran.r-project.org/web/packages/RcppOctave/index.html).

Requires RBGL, Octave, and RcppOctave (verified to work with version 3.8.1 and 0.14.5 respectively)



## Installation
  ```R
  install.packages('devtools')  # package devtools needed
  devtools::install_github('jsta/dciR')
  
  source("http://bioconductor.org/biocLite.R")
  biocLite("RBGL")
  #biocLite("Rgraphviz")
  ```
  
## Examples
   ```R
   #The example below reproduces figure 3 from Larsen et al. (2012)#####
   library(dciR)
      
   #load test matricies####
   ma <- matrix(c(0,0,1,0,0,0,1,0,1,0,0,1,0,0,1,0,0,0,1,0,1,1,0,0,0),nrow=5,byrow=T)
   mb <- matrix(c(1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0),nrow=5,byrow=T)
   mc <- matrix(c(1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1),nrow=5,byrow=T)
   md <- matrix(c(1,0,0,0,1,1,0,1,0,1,0,0,1,0,0,1,0,0,0,1,1,0,0,0,1),nrow=5,byrow=T)
   
   data.frame(cbind(letters[1:4],round(unlist(lapply(list(ma,mb,mc,md),function(x) dci(x,1,1))),3)))
   
   #The example below reproduces Figure 4####
   library(jpeg)
   library(raster)
   
   c1<-readJPEG(system.file("images","conserved1.jpg",package="dciR"))
   c2<-readJPEG(system.file("images","conserved2.jpg",package="dciR"))
   s1<-readJPEG(system.file("images","sim1.jpg",package="dciR"))
   r1<-readJPEG(system.file("images","rotated1.jpg",package="dciR"))
   d1<-readJPEG(system.file("images","degraded1.jpg",package="dciR"))
   
   
   c1<-raster(matrix(c1,nrow=dim(c1)[1],ncol=dim(c1)[2]))<0.4
   c2<-raster(matrix(c2,nrow=dim(c2)[1],ncol=dim(c2)[2]))<0.4
   s1<-raster(matrix(s1,nrow=dim(s1)[1],ncol=dim(s1)[2]))<0.4
   r1<-raster(matrix(r1,nrow=dim(r1)[1],ncol=dim(r1)[2]))<0.4
   d1<-raster(matrix(d1,nrow=dim(d1)[1],ncol=dim(d1)[2]))<0.4
   
   par(mfrow=c(1,5))
   lapply(c(c1,c2,s1,r1,d1),function(x) plot(x,bty="n",box=FALSE,axes=FALSE,legend=FALSE))
   ```
  
   ![](inst/images/fig4.png)
   
   ```R
   
   #The example below reproduces Figure 5####
   ret<-list()
   aglist<-10:22
   
   ag_dci<-function(c1,ag){
   c1r<-aggregate(c1,ag,fun=median)>0.7
   c1mat<-as.matrix(c1r)
   time<-system.time(val<-dci(c1mat,1,1))
   list(time,val,sum(c1mat))
   }
      
   for(i in aglist){
   ret[[i]]<-ag_dci(c1,i)
   }
      
   ret<-cbind(matrix(unlist(ret),ncol=7,byrow=T),aglist)
   
   par(mfrow=c(1,2))
   plot(ret[,7]/10000,ret[,1],log="y",yaxt="n",xlim=c(0,3),ylim=c(1,1000),xlab="Number of nodes x 10^4",ylab="Computation time (s)")
   labels<-sapply(seq(0,3,1),function(i) as.expression(bquote(10^ .(i))))
   axis(2,at=c(1,10,100,1000),labels=labels)
   
   plot(ret[,7]/10000,ret[,1],xlab="Number of nodes x 10^4",ylab="")
   
   ```
   ![](inst/images/fig5.png)
   ```R
      
   #The example below reproduces Figure 6
   
   ret<-matrix(unlist(lapply(c(c1,c2,s1,d1),function(x) ag_dci(x,16))),ncol=7,byrow=T)
   barplot(ret[,6],names.arg=c("Conserved1","Conserved2","Sim1","Degraded1"),ylim=c(0,1),las=2)
   ```
   
   ![](inst/images/fig6.png)
      
   
## References 

**Larsen, L. G., Choi, J., Nungesser, M. K., & Harvey, J. W. (2012)**. Directional connectivity in hydrology and ecology. *Ecological applications*, **22**(8), 2204-2220.