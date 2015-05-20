#'@name dciu_rbgl
#'@title Directional connectivity index distance looping
#'@export
#'@examples mat <- matrix(c(0,0,1,0,0,0,1,0,1,0,0,1,0,0,1,0,0,0,1,0,1,1,0,0,0),nrow=5,byrow=T)
#'xgrain<-1
#'ygrain<-1
#'#run first part of dci.R through dciu_pre
#'adjacency<-adj$adjacency
#'start_nodes<-dciu_pre$start_nodes
#'pixelx<-adj$pixelx
#'R<-dciu_pre$R
#'dist<-adj$distance
#'dx<-dciu_pre$dx

dciu_rbgl<-function(start_nodes,adjacency,dist,pixelx,R,dx,adjL){
  num<-0
  den<-0
  #dx<-1
  
  #construct graph object####
  #dist<-adj$distance
  g1<-new("distGraph",as.dist(dist))
  
  diag(dist)<-NA
  dist<-matrix(dist[which(!is.na(dist))],nrow=nrow(dist)-1)
     
  wL<-list()
  for(i in 1:length(edgeWeights(g1))){
    wL[[i]]<-dist[,i][dist[,i]!=0]
  }
  wL<-matrix(unlist(wL),ncol=1)
  
  adjLfull<-list()
  for(i in 1:length(adjL)){
    adjLfull[[i]]<-cbind(rep(as.character(i),length(adjL[[i]])),as.character(adjL[[i]]))
  }
    adjLfull<-do.call("rbind",adjLfull)
  
  adjLfull<-adjLfull[apply(adjLfull,1,function(x) !identical(x[1],x[2])),]
  g2<-ftM2graphNEL(adjLfull,wL,edgemode="directed")
  
  #loop through graph####
  
  for(i in 1:length(start_nodes)){
    #print(i)
    #i<-1
    if(any(nodes(g2)==as.character(start_nodes[i]))){
    d<-dijkstra.sp(g2,start=as.character(start_nodes[i]))$distances
    r<-pixelx[i]
    for(j in r+1:R){
      #j<-r+2
      end_nodes <- which(pixelx %in% j)
      if(length(end_nodes)!=0){
        dij<-min(d[end_nodes],na.rm=T)
        num<- num+dx*(j-r)/dij
        den<-den+1
      }
    }
  }
  }
  num/den
    
}