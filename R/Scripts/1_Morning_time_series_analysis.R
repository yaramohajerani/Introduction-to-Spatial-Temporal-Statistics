##############################################################################
##-----------------------------Morning--------------------------------------##
##############################################################################
rm(list=ls())
library(nlme)

#############################################################################
## Random and correlated sequences ##########################################
#############################################################################

#############################################################################
## El Nino time series ######################################################
#############################################################################
sst <- read.table('http://www.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/detrend.nino34.ascii.txt',header=TRUE)
y   <- sst$TOTAL
t   <- seq(1950,2017,length.out=nrow(sst))
summary(lm(y ~ t))

###################################################################################
## What generates the pattern? ####################################################
###################################################################################


###################################################################################
## Is there a trend? ##############################################################
###################################################################################

###################################################################################
## Sample realizations of correlated and uncorrelated data ########################
###################################################################################
pdf('D:/Dropbox/Teaching/Bayes/DSI/plots/realizations.pdf',height=5,width=8)
par(mfrow=c(2,2),mar=c(3,4,3,3),cex.axis=0.8)
#	plot(replicate(1,arima.sim(200,model=list(ar=0.95))),type='l',ylab='',xlab='',ylim=c(-10,10))
	matplot(replicate(3,rnorm(100)),type='l',ylab='',xlab='',col='black',ylim=c(-10,10))
	matplot(replicate(3,arima.sim(100,model=list(ar=0.95))),type='l',ylab='',xlab='',col='black',ylim=c(-10,10))
	matplot(replicate(100,rnorm(100)),type='l',ylab='',xlab='',col='black',ylim=c(-10,10))
	matplot(replicate(100,arima.sim(100,model=list(ar=0.95))),type='l',ylab='',xlab='',col='black',ylim=c(-10,10))
dev.off()

x <- as.numeric(arima.sim(200,model=list(ar=0.8),sd=0.5)) + 27

pdf('D:/Dropbox/Teaching/Bayes/DSI/plots/t_tp1.pdf',height=7,width=7)
par(mar=c(2,2,2,2),mfrow=c(3,3),cex.axis=0.9)
	for(i in 1:9){
		plot(x[1:(length(x)-i)],x[(i+1):length(x)],xlab='',ylab='',ylim=c(24,29),xlim=c(24,29))
		abline(0,1,lty=2,lwd=2)
		abline(lm(x[(i+1):length(x)] ~ x[1:(length(x)-i)]),lwd=2)
	}
dev.off()

pdf('D:/Dropbox/Teaching/Bayes/DSI/plots/var_y.pdf',height=4,width=4)
	plot(seq(0,0.98,0.01),1/(1-seq(0,0.98,0.01)^2),bty='n',type='l')
dev.off()	

options(repr.plot.width=9, repr.plot.height=5)
par(mfrow=c(2,3),mar=c(3,4,3,1),cex.axis=0.95)
acf(y1,lag.max=T,main='',ci=0,ylab='Autocorrelation function'); mtext('y1')
acf(y2,lag.max=T,main='',ci=0,ylab=''); mtext('y2')
acf(y3,lag.max=T,main='',ci=0,ylab=''); mtext('y3')
acf(y1,lag.max=T,main='',ci=0); mtext('Autocovariance function')
acf(y2,lag.max=T,main='',ci=0); mtext('')
acf(y3,lag.max=T,main='',ci=0); mtext('')

a <- 0.95
x <- 0
for (i in 2:200){
	
	xtp1 <- a*x[i-1] + rnorm(1) 
	x    <- c(x,xtp1)
}

pdf('D:/Dropbox/Teaching/Bayes/DSI/plots/eye_tricks.pdf',height=4,width=6)
	plot(x,type='l',lwd=2)
dev.off()

pdf('D:/Dropbox/Teaching/Bayes/DSI/plots/autocorrelation_0.95_0.7.pdf',height=4,width=8)
par(mfrow=c(1,2))
	plot(c(1,0.98,0.96^seq(1,100,0.5)),type='l',ylim=c(0,1),lwd=2,ylab='Correlation',xlab='')
	abline(h=0,lty=2)
	plot(c(1,0.7^seq(1,100,0.5)),type='l',ylim=c(0,1),lwd=2,ylab='',xlab='')
	abline(h=0,lty=2)
dev.off()


###################################################################################
## Simulate time series with various properties  ##################################
###################################################################################
T        <- 365*5 
ts       <- 1:T
y0       <- 10
a        <- 0.95
s        <- 5
y1=y2=y3 <- 200
b        <- (2*pi/365)
p        <- 2*sin(b*(1:T))

for(i in 2:T){
   y1tp1 <- y0    + a*y1[i-1] + p[i] + rnorm(1,0,s) 
   y2tp1 <- y2[1] +             p[i] + rnorm(1,0,s)   
   y3tp1 <- y3[1]                    + rnorm(1,0,s)
   y1    <- c(y1,y1tp1)
   y2    <- c(y2,y2tp1)
   y3    <- c(y3,y3tp1) 
}

options(repr.plot.width=9, repr.plot.height=2.5)
par(mfrow=c(1,3),mar=c(3,4,3,1),cex.axis=0.95)
plot(y1,type='l')
plot(y2,type='l')
plot(y3,type='l')

###################################################################################
## GLS vs. OLS simulation #########################################################
###################################################################################





####################################################################################
## Basic fit elNino using GLS ######################################################
####################################################################################

#####################################################################################
#####################################################################################
##---------------------------------------------------------------------------------##
##------------------------------BREAK----------------------------------------------##
##---------------------------------------------------------------------------------##
#####################################################################################
#####################################################################################

#####################################################################################
## Analysis of Orange country ozone data ############################################
#####################################################################################
d <- read.csv('D:/Dropbox/Teaching/Bayes/DSI/Environmental_Stats_with_Stan/Data/ozone_orange.csv',stringsAsFactors=FALSE)
d <- d[d$year!=2016,]
d$year <- d$year + 6

pdf('D:/Dropbox/Teaching/Bayes/DSI/plots/ozone_time_series.pdf',height=5,width=8)
par(mfrow=c(3,2),mar=c(3,4,1,1))
	plot(d$ozone,type='l',ylab='Mean Ozone [ppb]')
	#plot(d$ozone_max)
	plot(d$aqi,type='l',ylab='Air Quality Index')
	#plot(d$pressure)
	plot(d$humidity,type='l',ylab='Humidity [%]')
	plot(d$temp,type='l',ylab='Temperature [F]')
	plot(d$windsp,type='l',ylab='Wind Speed [m/s]')
	plot(d$winddir,type='l',ylab='Wind Direction [degree]')
dev.off()

#####################################################################################
## Simple trend analysis ############################################################
#####################################################################################
y1 <- d$ozone
y2 <- d$ozone_max
y3 <- d$hour_max
y4 <- d$aqi
y5 <- d$pressure
y6 <- d$humidity
y7 <- d$temp
y8 <- d$windsp
y9 <- d$winddir

t <- seq(min(d$year),max(d$year),length.out=length(y1))

summary(lm(y1 ~ t))
summary(lm(y2 ~ t))
summary(lm(y3 ~ t))
summary(lm(y4 ~ t))
summary(lm(y5 ~ t))
summary(lm(y6 ~ t))
summary(lm(y7 ~ t))
summary(lm(y8 ~ t))
summary(lm(y9 ~ t))

summary(gls(y1 ~ t, correlation=corAR1()))
summary(gls(y2 ~ t, correlation=corAR1()))
summary(gls(y3 ~ t, correlation=corAR1()))
summary(gls(y4 ~ t, correlation=corAR1()))
summary(gls(y5 ~ t, correlation=corAR1()))
summary(gls(y6 ~ t, correlation=corAR1()))
summary(gls(y7 ~ t, correlation=corAR1()))
summary(gls(y8 ~ t, correlation=corAR1()))
summary(gls(y9 ~ t, correlation=corAR1()))

#####################################################################################
## Harmonic regression ##############################################################
#####################################################################################
nyrs  	  <- max(d$year)-min(d$year)
ndys  	  <- nyrs*365
f         <- seq(0,(2*pi)*nyrs,length.out=nrow(d))
	sinf  <- sin(f)
	cosf  <- cos(f)
f1        <- seq(0,2*pi*(nyrs/0.99),length.out=nrow(d))
	sinf2 <- sin(f1)
	cosf2 <- cos(f1)
f2        <- seq(0,2*pi*(nyrs/0.8),length.out=nrow(d))
	sinf2 <- sin(f2)
	cosf2 <- cos(f2)
	
f3    	  <- seq(0,2*pi*(nyrs/4),length.out=nrow(d))
	sinf3 <- sin(f3)
	cosf3 <- cos(f3)
f4        <- seq(0,2*pi*(nyrs/8),length.out=nrow(d))
	sinf4 <- sin(f4)
	cosf4 <- cos(f4)
f5    	  <- seq(0,2*pi*(nyrs/16),length.out=nrow(d))
	sinf5 <- sin(f5)
	cosf5 <- cos(f5)
f6        <- seq(0,2*pi*(nyrs/32),length.out=nrow(d))
	sinf6 <- sin(f6)
	cosf6 <- cos(f6)

summary(lm(y1 ~ sinf1+cosf1 + sinf2+cosf2 + sinf3+cosf3 + sinf4+cosf4 + sinf5+cosf5 + sinf6+cosf6))
summary(lm(y2 ~ sinf1 + cosf1 + sinf2 + cosf2))
summary(lm(y3 ~ sinf1 + cosf1 + sinf2 + cosf2))
summary(lm(y4 ~ sinf1 + cosf1 + sinf2 + cosf2))
summary(lm(y5 ~ sinf1 + cosf1 + sinf2 + cosf2))
summary(lm(y6 ~ sinf1 + cosf1 + sinf2 + cosf2))
summary(lm(y7 ~ sinf1 + cosf1 + sinf2 + cosf2))
summary(lm(y8 ~ sinf1 + cosf1 + sinf2 + cosf2))
summary(lm(y9 ~ sinf1 + cosf1 + sinf2 + cosf2))

fity1 <- lm(y1 ~ sinf1+cosf1 + sinf2+cosf2 + sinf3+cosf3 + sinf4+cosf4 + sinf5+cosf5 + sinf6+cosf6)
plot(y1)
lines(predict(fity1),lwd=2)



ugh <- b*ts
fitytar <- gls(y1  ~ ts + sin(ugh) + cos(ugh), correlation = corAR1())
summary(fitytar)$tTable[,1:2]



options(repr.plot.width=9, repr.plot.height=2.5)
par(mfrow=c(1,3),mar=c(3,4,3,1),cex.axis=0.95)
plot(p,type='l',ylab='p(t)',lwd=2)
plot(p,y1-mean(y1),pch=19)
matrix(paste('Correlation of y1 with the seasonal period = ',round(cor(p,y1-mean(y1)),5)))

fity1 <- lm(y1 ~ sin(b*ts) + cos(b*ts)); summary(fity1)$coefficients[,1:2]
fity2 <- lm(y2 ~ sin(b*ts) + cos(b*ts)); summary(fity2)$coefficients[,1:2]
fity3 <- lm(y3 ~ sin(b*ts) + cos(b*ts)); summary(fity3)$coefficients[,1:2]


####################################################################################
## Aliasing ########################################################################
####################################################################################


####################################################################################
## Aside on power spectrum #########################################################
####################################################################################
pdf('D:/Dropbox/Teaching/Bayes/DSI/plots/spectrum.pdf',height=4,width=6)
par(mar=c(3,4,3,2))
	plot(spec.pgram(y1,demean=TRUE,detrend=TRUE,plot=FALSE),xlim=c(0,0.05),main='',ylab='Spectral Density')
	box(lwd=1.5)
	abline(v=1/365,lwd=1.5,lty=2)
dev.off()	

####################################################################################
## Time series decomposition #######################################################
####################################################################################
fit     <- gls(y1 ~ sinf + cosf + t,correlation=corAR1())
k_hat   <- summary(fit)$t
phi_hat <- coef(fit$model$corStruct,unconstrained=FALSE)
e <- residuals(fit)
n <- length(e)

par(mfrow=c(2,2),mar=c(3,4,2,2))
plot(y1,type='l',ylim=c(0,0.07),ylab='ozone [ppb]')

f_hat <- mean(y1) + k_hat[2,1]*sinf + k_hat[3,1]*cosf
plot(f_hat,type='l',ylim=c(0,0.07),ylab='')
	lines(f_hat + 2*sqrt(k_hat[2,2]^2 + k_hat[3,2]^2),lty=2)
	lines(f_hat - 2*sqrt(k_hat[2,2]^2 + k_hat[3,2]^2),lty=2)

t_hat <- k_hat[1,1] + k_hat[4,1]*t
t_hat <- t_hat - mean(t_hat)
plot(t_hat-mean(t_hat), type='l',ylim=c(-0.001,0.001),ylab='ozone [ppb]')
	lines(t_hat + 2*k_hat[4,2],lty=2)
	lines(t_hat - 2*k_hat[4,2],lty=2)
	abline(h=0)
ear <- e[2:n]-phi_hat*e[1:(n-1)]
plot(mean(y1)+ear,type='l',ylim=c(0,0.07),ylab='')

##################################################################################
## Time series regression ########################################################
##################################################################################
x1  <- d$temp
x2  <- d$windsp
x3  <- d$winddir 

fitx1   <- gls(y1 ~ sinf + cosf + x1,correlation=corAR1(),method='ML')
fitx123 <- gls(y1 ~ sinf + cosf + x1 + x2 + x2,correlation=corAR1(),method='ML')

plot(residuals(fitx1, 'response'),pch=8,cex=0.7)
plot(residuals(fitx1, 'pearson'),pch=8,cex=0.7)
plot(residuals(fitx1, 'normalized'),pch=8,cex=0.7)


plot(y1)

##################################################################################
## Model selection ###############################################################
##################################################################################
BIC(fitx1,fitx123)

