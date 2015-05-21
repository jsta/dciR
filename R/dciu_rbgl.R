#'@name dciu_rbgl
#'@import RBGL
#'@import graph
#'@title Directional connectivity index distance looping
#'@param start_nodes list of nodes
#'@param adjacency matrix representing adjacency among nodes
#'@param dist a distance matrix taking into account longer diagonal distances
#'@param pixelx the rows positions of each node
#'@param R integer number of matrix ros
#'@param dx numeric cell (grain) distance
#'@param adjL list of adjacent nodes
#'@export

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
  pb<-txtProgressBar(style=3,min=1,max=length(start_nodes))
  
  for(i in 1:length(start_nodes)){
    setTxtProgressBar(pb,i)
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
  close(pb)
  
  num/den
    
}