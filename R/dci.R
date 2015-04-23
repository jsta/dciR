#'@name dci
#'@title Directional connectivity matrix
#'@export

dci<-function(mat,xgrain,ygrain){
    
  fpath<-system.file("Octave","aont","adj2adjL.m",package="dciR")
  o_source(fpath)
  cpath<-system.file("Octave","aont","dijkstra_edit.m",package="dciR")
  o_source(cpath)
  tpath<-system.file("Octave","larsen2012","DCIu_aont.m",package="dciR")
  o_source(tpath)
  dpath<-system.file("Octave","larsen2012","im2adjacency_full.m",package="dciR")
  o_source(dpath)
    
  adj<-.O$im2adjacency_full(mat,xgrain,ygrain)
  o_assign(xgrain=xgrain)
  o_assign(dist=adj$distance)
  o_assign(pixelx=adj$pixelx)
  o_eval("DCIu(dist,xgrain,pixelx)")
}