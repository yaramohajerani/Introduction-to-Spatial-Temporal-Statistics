##############################################################################
##-----------------------------Afternoon------------------------------------##
##############################################################################
rm(list=ls())
library(nlme)
library(fields)
library(colorRamps)
library(gstat)
library(sp)
##############################################################################
## What generates the pattern? ###############################################
##############################################################################

##############################################################################
## Simulate MV normal spatial data ###########################################
##############################################################################
M  	<- expand.grid(1:30, 1:30)
n  	<- nrow(M)
D  	<- as.matrix(dist(M))
r  	<- 0.1
s  	<- 10
S 	<- s^2*exp(-r*D)
L  <- chol(S)
Si <- chol2inv(L)
Li <- solve(L)
par(mfrow=c(2,2))
image.plot(S)
hist(c(D))

x0  <- matrix(rnorm(n), ncol=n)
x   <- x0%*%L
x00 <- x%*%Li

par(mfrow=c(2,2))
image.plot(as.matrix(xtabs(t(x0)  ~ M[,1] + M[,2])))
image.plot(as.matrix(xtabs(t(x)   ~ M[,1] + M[,2])))
image.plot(as.matrix(xtabs(t(x00) ~ M[,1] + M[,2])))

################################################################################
## Visualize Oregon climate station data #######################################
################################################################################
d <- read.csv('D:/Dropbox/Teaching/Bayes/DSI/Environmental_Stats_with_Stan/Data/oregon_temp_precip.csv',header=TRUE)
cols <- matlab.like(100)[as.numeric(cut(d$temp_jan,breaks=100))]
plot(d$lon,d$lat,col=cols,pch=19)

####################################################
## Krigeing interpolation ##########################
####################################################
ds <- d												#copy data.frame to give coordinates
coordinates(ds) <- ~ lon + lat                      #define coordinates; this makes ds of class 'sp', a 'spatial data frame'
proj4string(ds)=CRS("+proj=longlat +datum=WGS84")   #project the lat lon using equal area

d_evg <- variogram(temp_jan ~ 1, ds, cutoff=700)   #estimate the empirical variogram (approx. 1-autocovariance)

plot(d_evg$dist, d_evg$gamma)                       #take a look
par(new=TRUE)                                       #overplot
plot(d_evg$np,xaxt='n',yaxt='n',xlab='',ylab='',type='l') #plot the number of values in each distance bin

d_vg = fit.variogram(d_evg, 
					 model=vgm(psill=20,model="Exp",range=300,nugget=0.2*mean(ds$temp_jan)), 
					 fit.ranges=FALSE)              #this aids convergence issues for this particular dataset
plot(d_evg,d_vg)                                    #take a look

##############################
## Krigeing prediction #######
##############################
latr <- as.integer(range(ds$lat))             #define latitude range for interpolation domain
lonr <- as.integer(range(ds$lon))			   #define longitude range for interpolation domain

res  <- 0.05                                   #define resolution of interpolation domain [degrees]
lat0 <- seq(from=latr[1], to=latr[2], by=res)  #regularly gridded input latitudes
lon0 <- seq(from=lonr[1], to=lonr[2], by=res)  #regularly gridded input longitudes
grd <- expand.grid(lon=lon0,lat=lat0)          #list points
coordinates(grd) <- ~ lon + lat                #define the coordinates; transforms grd from class data.frame to class sp
proj4string(grd) <- CRS("+proj=longlat +datum=WGS84") #project lat/lon using equal area projection
#gridded(grd) <- TRUE                           #

d_k = krige(formula=temp_jan ~ 1, locations=ds, newdata=grd, model=d_vg)
dkdf <- as.data.frame(d_k)

par(mfrow=c(1,2))
image.plot(lon0,lat0,xtabs(dkdf[,3] ~ dkdf[,1] + dkdf[,2]))
cols <- matlab.like(100)[as.numeric(cut(d$temp_jan,breaks=100))]
points(d$lon,d$lat,col=cols,pch=19)
points(d$lon,d$lat,col='white')

image.plot(lon0,lat0,xtabs(dkdf[,4] ~ dkdf[,1] + dkdf[,2]))
points(d$lon,d$lat,col='white')

##############################################################################
## Spatial regression ########################################################
##############################################################################
fit <- gls(precip_ann ~ temp_annual, data=d, correlation=corExp(form=~lat+lon,nugget=FALSE),method='ML')
summary(fit)

fit2 <- gls(precip_ann ~ temp_annual + elevation, data=d, correlation=corExp(form=~lat+lon,nugget=FALSE),method='ML')
summary(fit2)

y      <- predict(fit2)
latlon <- cbind(d$lon,d$lat)
fit <- likfit(data=y,coords=latlon,
	fix.nugget=TRUE,
	cov.model="exponential",
	ini=c(30,5),
	nugget=FALSE, 
	lik.method = "ML")	
phi_hat <- fit$cov.pars[2]
s2_hat <- fit$cov.pars[1]

lon0    <- seq(min(latlon[,1]),max(latlon[,1]),length=100)
lat0    <- seq(min(latlon[,2]),max(latlon[,2]),length=100)
latlon0 <-expand.grid(lon0,lat0)
pred <- krige.conv(data=y,
				   coords=latlon,
				   locations=latlon0,
				   krige=krige.control(cov.model="exponential",
					cov.pars=c(s2_hat,phi_hat),nugget=s_obs)
)

par(mfrow=c(1,2))	
image.plot(lon0,lat0,matrix(pred$predict,100,100),zlim=range(y))
	cols <- matlab.like(100)[as.numeric(cut(y,breaks=100))]
	points(latlon,col=cols,pch=19)
	points(latlon,col='white')

