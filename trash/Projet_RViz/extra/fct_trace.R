#recentrage du repère
pt_recentrage=function(p1,p2){
    if(abs(p1[1])>=abs(p2[1])){return(p2)} else {return(p1)}}


recentrage=function(p1,p2){return(c(p1,p2)-pt_recentrage(p1,p2))}

#on veut des angles <pi/2 donc on change l'orientation du vecteur
vecteur_recentre=function(p1,p2){
    vect=c(p1[1]-p2[1],p1[2]-p2[2])
    if (vect[1]<0){
        return(-vect)}else {return(vect)}
}

dist_euclidean=function(p1,p2){
    return(sqrt(sum((p1-p2)^2)))
}

#vecteur orthogonal à (p1p2)
vecteur_ortho=function(vc_recentre){
    return(c(-vc_recentre[2]/vc_recentre[1],1))
}

#calcul du delta selon la courbure voulue
delta=function(p1,p2,alpha){
    return(0.5*dist_euclidean(p1,p2)*sin(alpha*pi/180))
}

#retourne c(cos beta, sin beta)
angle_beta=function(vc_recentre,p1,p2){
    return(c(vc_recentre[1],vc_recentre[2])/dist_euclidean(p1,p2))
}

#projection sur (x*,y*)
proj=function(pt,beta){
    return(c(pt%*%beta,-pt[1]*beta[2]+pt[2]*beta[1]))
}

#polynome interpolateur de lagrange pour x1,x2~,x~m valant delta en xm~ le milieu
Lagrange=function(x,p1_proj,p2_proj,delta){
    
    return(-4*delta*(x-p1_proj[1])*(x-p2_proj[1])/((p1_proj[1]-p2_proj[1])^2))}

#calcul des n points (xi,yi) dans la base (x*,y*)
Calcul_points=function(n,p1_proj,p2_proj,delta){
    C=as.data.frame(c())
    for (i in seq(min(p1_proj[1],p2_proj[1]),max(p1_proj[1],p2_proj[1]),length.out= n)){
        C=rbind(C,c(i,Lagrange(i,p1_proj,p2_proj,delta)))
    }
    return(C)}

#retour dans la base (x,y)
Retour_base=function(C,angle_beta,p1,p2,n){
    C_xy=as.data.frame(c())
    for (i in 1:n){
        C_xy=rbind(C_xy,c(angle_beta[1]*C[i,1]-angle_beta[2]*C[i,2],angle_beta[2]*C[i,1]+angle_beta[1]*C[i,2])+pt_recentrage(p1,p2))
    }
    return(C_xy)}

#assemblage de l'algo
coord_flux=function(pa,pb,alpha,n){
    p1_r<-recentrage(pa,pb)[1:2]
    #print(p1_r)
    p2_r<-recentrage(pa,pb)[3:4]
    #print(p2_r)
    vc_recentre<-vecteur_recentre(p1_r,p2_r)
    #print(vc_recentre)
    vc_ortho<-vecteur_ortho(vc_recentre)
    #print(vc_ortho)
    beta<-angle_beta(vc_recentre,p1_r,p2_r)
    #print(beta)
    p1_b<-proj(p1_r,beta)
    #print(p1_b)
    p2_b<-proj(p2_r,beta)
    #print(p2_b)
    delta<-delta(p1_b,p2_b,alpha)
    #print(delta)
    
    points_xy_chap<-Calcul_points(n,p1_b,p2_b,delta)
    #print(points_xy_chap)
    points<-Retour_base(points_xy_chap,beta,pa,pb,n)
    #print(points)
    names(points) <- c("lon", "lat")
    return(points)}

#NB: il est conseillé de forcer le nom des colonnes pour l'intégration avec Leaflet

#transformation en SpatialLines object
trans_sp=function(points,Id){
    
    return(SpatialLines(list(Lines(list(Line(points)),ID=Id))))
}
#NB: il faut spécifier un ID pour chaque ligne, il n'est pas utile ici mais requis par le format sp utilisé

#fonction décrite, A,B de la forme c(x_a,y_a), N le nombre de flows voulus, n le nb de pts intermédiaires
#et alpha l'incrément pour la courbure 
N_flows_OD=function(pa,pb,N,n=20,alpha=10){
    f_flows<-c()
    if(N%%2==1){
        f_flows<-trans_sp(coord_flux(pa,pb,0,n),as.character(1))
        if(N>1){
            for (i in 2:N){
                f_flows<- rbind(f_flows,trans_sp(coord_flux(pa,pb,floor(i/2)*alpha*(-1)^(i),n),as.character(i)))}
        }
    } else {
        f_flows<-rbind(trans_sp(coord_flux(pa,pb,alpha,n),as.character(1)),trans_sp(coord_flux(pa,pb,-alpha,n),as.character(2)))
        
        if(N>2){
            for (j in 3:N){
                f_flows<- rbind(f_flows,trans_sp(coord_flux(pa,pb,floor(j/2)*alpha*(-1)^(j),n),as.character(j)))}
        }
        
    }
    return(f_flows)}

#NB on note qui si N s'approche de 18, il faut revoir l'incrément à la baisse
#Cela semble peu probable dans notre projet mais possible pour d'autres données (finance,basket)?
