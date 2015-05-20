#'@name dci
#'@title Directional connectivity matrix
#'@param mat matrix 2D matrix of zeros and ones, in which ones represent the landscape patch of interest. The axis of interest along which directional connectivity is computed is dimension 1 of this matrix.
#'@param xgrain pixel length in cm (i.e., along dimension 1 of the variable "state")
#'@param ygrain pixel width in cm (i.e., along dimension 2 of the variable "state")
#'@details This function first converts a binary image to an adjacency matrix (larsen::im2adjacency). Next, this matrix is fed into a modified version of DCIu (DCIu_aont). DCIu_aont calls an underlying distance function in the process of returning a DCI value. The distance function (dijkstra_edit) requires requires an adjacency list which is created with the adj2adjL function.
#'@export

dci<-function(mat,xgrain,ygrain){
    
  aontfiles<-c("adj2adjL.m","dijkstra_edit.m")
  for(i in 1:length(aontfiles)){
    o_source(system.file("Octave","aont",aontfiles[i],package="dciR"))    
  }
  
  larsen2012files<-c("DCIu_aont.m","im2adjacency_full.m")
  for(i in 1:length(larsen2012files)){
    o_source(system.file("Octave","larsen2012",larsen2012files[i],package="dciR"))    
  } 
      
  adj<-.O$im2adjacency_full(mat,xgrain,ygrain)
  o_assign(xgrain=xgrain)
  o_assign(dist=adj$distance)
  o_assign(pixelx=adj$pixelx)
  o_eval("DCIu(dist,xgrain,pixelx)")
}