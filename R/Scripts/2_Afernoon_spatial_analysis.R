##############################################################################
##-----------------------------Afternoon------------------------------------##
##############################################################################
rm(list=ls())
library(nlme)
library(fields)
library(colorRamps)
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
d <- read.csv('oregon_temp_precip.csv',header=TRUE,stringsAsFactors=FALSE)
cols <- matlab.like(100)[as.numeric(cut(d$temp_jan,breaks=100))]
plot(d$lon,d$lat,col=cols,pch=19)

####################################################
## Krigeing interpolation ##########################
####################################################
y      <- d$temp_annual
latlon <- cbind(d$lon,d$lat)
s_obs  <- 2
fit <- likfit(data=y,coords=latlon,
	fix.nugget=TRUE,
	cov.model="exponential",
	ini=c(30,5),
	nugget=s_obs, 
	lik.method = "ML")
phi_hat <- fit$cov.pars[2]
s2_hat <- fit$cov.pars[1]

##############################
## Krigeing prediction #######
##############################
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
image.plot(sp1,sp2,matrix(sqrt(pred$krige.var),100,100))
points(latlon,col='white')


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

