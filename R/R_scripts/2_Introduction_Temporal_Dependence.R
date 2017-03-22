###################################################################################
##  ############################################
###################################################################################

#-Simulate time series-#
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

##########################################################
## Periodicity ###########################################
##########################################################
options(repr.plot.width=9, repr.plot.height=2.5)
par(mfrow=c(1,3),mar=c(3,4,3,1),cex.axis=0.95)
plot(p,type='l',ylab='p(t)',lwd=2)
plot(p,y1-mean(y1),pch=19)
matrix(paste('Correlation of y1 with the seasonal period = ',round(cor(p,y1-mean(y1)),5)))

fity1 <- lm(y1 ~ sin(b*ts) + cos(b*ts)); summary(fity1)$coefficients[,1:2]
fity2 <- lm(y2 ~ sin(b*ts) + cos(b*ts)); summary(fity2)$coefficients[,1:2]
fity3 <- lm(y3 ~ sin(b*ts) + cos(b*ts)); summary(fity3)$coefficients[,1:2]

###############################################################################
## The autocorrelation function ###############################################
###############################################################################
options(repr.plot.width=9, repr.plot.height=5)
par(mfrow=c(2,3),mar=c(3,4,3,1),cex.axis=0.95)
acf(y1,lag.max=T,main='',ci=0,ylab='Autocorrelation function'); mtext('y1')
acf(y2,lag.max=T,main='',ci=0,ylab=''); mtext('y2')
acf(y3,lag.max=T,main='',ci=0,ylab=''); mtext('y3')
acf(y1,lag.max=T,main='',ci=0); mtext('Autocovariance function')
acf(y2,lag.max=T,main='',ci=0); mtext('')
acf(y3,lag.max=T,main='',ci=0); mtext('')



############################################################################
## Decomposition ###########################################################
############################################################################
T  <- 365*5   #[days]
y0 <- 10      #[x/x]
a  <- 0.95
s  <- 10
yt <- 200
e  <- 0
b  <- (2*pi/365)
p  <- 2*sin(b*(1:T))
bt <- 0.1 

for(t in 2:T){
   etp1 <- a*e[t-1] + rnorm(1,0,s)
   ytp1 <- yt[1] + bt*t + p[t] + etp1  
   yt   <- c(yt,ytp1)
   e    <- c(e,etp1)
}

options(repr.plot.width=9, repr.plot.height=2.5)
par(mfrow=c(1,3),mar=c(3,4,3,1),cex.axis=0.95)
plot(yt,type='l')

library(nlme)
w <- b*ts
fityt   <- lm(yt ~ ts + sin(b*ts)); fitytp  <- summary(fityt)$coefficients[,1:2]; fitytp
    e   <- residuals(fityt)[2:T]
options(repr.plot.width=9, repr.plot.height=2.5)
par(mfrow=c(1,3),mar=c(3,4,3,1),cex.axis=0.95)
plot(fitytp[2,1]*ts,type='l',lwd=2)
plot(fitytp[3,1]*sin(b*ts),type='l',lwd=2)
plot(e,type='l',lwd=2)


options(repr.plot.width=9, repr.plot.height=2.5)
par(mfrow=c(1,3),mar=c(3,4,3,1),cex.axis=0.95)
acf(e,lag.max=100,main='',ci=0)
plot(e[1:(t-1)],e[2:T],col='grey')
ereg <- lm(e[2:T] ~ e[1:(t-1)])
cor(as.numeric(e[2:T]),as.numeric(e[1:(t-1)]),use="complete.obs")

abline(ereg,lwd=2)
summary(ereg)$coefficients[,1:2] 
acf(e,lag.max=100,main='',ci=0)
lines(exp(-(1-0.94514)*seq(1,100)))


###############################################################################
## Trend analysis #############################################################
###############################################################################
T     <- 365*5   #[days]
y0    <- 10      #[x/x]
a     <- 0.95
s     <- 10
y3=y4 <- 200
b     <- (2*pi/365)
p     <- 2*sin(b*(1:T))
bt    <- 0.01 

for(t in 2:T){
   y3tp1 <- y0 + a*y3[t-1] + bt*t + p[t] + rnorm(1,0,s)  
   y4tp1 <- y4[1] + bt*t + rnorm(1,0,s)
   y3    <- c(y3,y3tp1)
   y4    <- c(y4,y4tp1)
}

options(repr.plot.width=7, repr.plot.height=2.5)
par(mfrow=c(1,2),mar=c(3,3,3,3))
plot(y3,type='l')
plot(y4,type='l')

#####################################
## Detrending #######################
#####################################
ts       <- 1:T
y3d <- y3 - predict(lm(y3 ~ seq(1,T)))
y4d <- y4 - predict(lm(y4 ~ seq(1,T)))

options(repr.plot.width=7, repr.plot.height=5)
par(mfrow=c(2,2),mar=c(3,3,3,3))
acf(y3,lag.max=T,main='')
acf(y4,lag.max=T,main='')
acf(y3d,lag.max=T,main='')
acf(y4d,lag.max=T,main='')

#####################################
## Seasonality ######################
#####################################
fity1 <- lm(y1 ~ sin(b*seq(1,T)) + cos(b*seq(1,T)))
fity2 <- lm(y2 ~ sin(b*seq(1,T)) + cos(b*seq(1,T)))
fity3 <- lm(y3 ~ sin(b*seq(1,T)) + cos(b*seq(1,T)))

library(nlme)
ugh <- b*ts
fitytar <- gls(y1  ~ ts + sin(ugh) + cos(ugh), correlation = corAR1())
summary(fitytar)$tTable[,1:2]

#####################################
## Realizations #####################
#####################################
pdf('D:/Dropbox/Teaching/Bayes/DSI/plots/realizations.pdf',height=5,width=8)
par(mfrow=c(2,2),mar=c(3,4,3,3),cex.axis=0.8)
	plot(replicate(1,arima.sim(200,model=list(ar=0.95))),type='l',ylab='',xlab='',ylim=c(-10,10))
	matplot(replicate(3,arima.sim(200,model=list(ar=0.95))),type='l',ylab='',xlab='',col='black',ylim=c(-10,10))
	matplot(replicate(100,arima.sim(200,model=list(ar=0.95))),type='l',ylab='',xlab='',col='black',ylim=c(-10,10))
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


