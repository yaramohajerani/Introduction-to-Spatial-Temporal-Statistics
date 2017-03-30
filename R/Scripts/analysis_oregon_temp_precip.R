rm(list=ls())
library(colorRamps) #custom colorbars
library(nlme)		#regression with autocorrelation	
library(geoR)		#spatial Krigeing
#######################################################################
## analysis_oregon_temp_precip ########################################
#######################################################################
d <- read.csv('D:/Dropbox/Teaching/Bayes/DSI/Environmental_Stats_with_Stan/Data/oregon_temp_precip.csv',header=TRUE,stringsAsFactors=FALSE)

##################################################
## Visualize #####################################
##################################################
cols <- matlab.like(100)[as.numeric(cut(d$temp_jan,breaks=100))]
plot(d$lon,d$lat,col=cols)

layout(matrix(1:2,ncol=2), width = c(2,1),height = c(1,1))
plot(d$lon,d$lat,col=cols)
legend_image <- as.raster(matrix(matlab.like(20), ncol=1))
plot(c(0,2),c(0,1),type = 'n', axes = F,xlab = '', ylab = '', main='')
text(x=1.5, y = seq(0,1,l=5), labels = seq(min(d$temp_jan),max(d$temp_jan),l=5))
rasterImage(legend_image, 0, 0, 1,1)

#######################################################
## Spatial regression #################################
#######################################################
#-Estimate the mean-#
summary(lm(temp_jan ~ 1, data=d))
summary(gls(temp_jan ~ 1, data=d,method='ML',correlation=corExp(form=~lat+lon,nugget=FALSE)))

#-Bivariate regression-#

fit <- gls(y ~ x, data=d, correlation=corExp(form=~lat+lon,nugget=FALSE),method='ML')

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
phi_hat <- ml$cov.pars[2]
s2_hat <- ml$cov.pars[1]

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


