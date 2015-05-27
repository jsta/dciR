#'@name dci
#'@import RBGL
#'@title Directional connectivity matrix
#'@param mat matrix 2D matrix of zeros and ones, in which ones represent the landscape patch of interest. The axis of interest along which directional connectivity is computed is dimension 1 of this matrix.
#'@param xgrain pixel length in cm (i.e., along dimension 1 of the variable "state")
#'@param ygrain pixel width in cm (i.e., along dimension 2 of the variable "state")
#'@details This function first converts a binary image to an adjacency matrix (larsen::im2adjacency). Next, this matrix is fed into a modified version of DCIu (DCIu_aont). DCIu_aont calls an underlying distance function in the process of returning a DCI value. The distance function (dijkstra_edit) requires requires an adjacency list which is created with the adj2adjL function.
#'@export
#'@examples
#'\dontrun{
#'mat <- matrix(c(0,0,1,0,0,0,1,0,1,0,0,1,0,0,1,0,0,0,1,0,1,1,0,0,0),nrow=5,byrow=TRUE)
#'mat<-matrix(c(1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0),nrow=5,byrow=TRUE)
#'xgrain<-1
#'ygrain<-1
#'dci(mat,xgrain,ygrain)
#'}

dci<-function(mat,xgrain,ygrain){
  requireNamespace(RcppOctave)  
  #run Octave####
  aontfiles<-c("adj2adjL.m","dijkstra_edit.m")
  for(i in 1:length(aontfiles)){
    RcppOctave::o_source(system.file("Octave","aont",aontfiles[i],package="dciR"))    
  }
  
  larsen2012files<-c("DCIu_preRBGL.m","im2adjacency_full.m")
  for(i in 1:length(larsen2012files)){
    RcppOctave::o_source(system.file("Octave","larsen2012",larsen2012files[i],package="dciR"))    
  } 
      
  adj<-RcppOctave::.O$im2adjacency_full(mat,xgrain,ygrain)
  RcppOctave::o_assign(xgrain=xgrain)
  RcppOctave::o_assign(dist=adj$distance)
  RcppOctave::o_assign(pixelx=adj$pixelx)
  adjL<-RcppOctave::.O$adj2adjL(adj$adjacency)
  dciu_pre<-RcppOctave::.O$DCIupre(adj$distance,xgrain,adj$pixelx)
  
  #run R####
  start_nodes<-dciu_pre$start_nodes
  adjacency<-adj$adjacency
  dist<-dciu_pre$distance
  pixelx<-adj$pixelx
  R<-dciu_pre$R
  dx<-dciu_pre$dx
   
  #Rprof()
  suppressMessages(dciu_rbgl(start_nodes,adjacency,dist,pixelx,R,dx,adjL))
  #Rprof(NULL)
  #summaryRprof()
}