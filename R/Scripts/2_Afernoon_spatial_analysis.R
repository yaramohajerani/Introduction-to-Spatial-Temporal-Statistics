rm(list=ls())
library(nlme)
library(fields)
##########################################################
## Simulate MV normal spatial data #######################
##########################################################
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

#########################################################
## Regression ###########################################
#########################################################
######################
## OLS ###############
######################

#y2 <- 2*x - 0.1*x^2 + rnorm(n)

X  <- cbind(rep(1,n),t(x))
#X2 <- cbind(rep(1,n),t(x),t(x^2))
b  <- solve(t(X)%*%X,   t(X)%*%t(y));b   		#solves the system of linear equations
#b2 <- solve(t(X2)%*%X2, t(X2)%*%t(y));b2

e    <- t(y) - X%*%b
sh   <- 1/n * t(e)%*%e
S0   <- as.numeric(sh)*diag(n)
S0i  <- chol2inv(chol(S0))
varb <- chol2inv(chol((t(X)%*%S0i%*%X))); sqrt(diag(varb))

######################
## GLS ###############
######################
bc  <- solve(t(X)%*%Si%*%X,   t(X)%*%Si%*%t(y)); bc
#bc2 <- solve(t(X2)%*%Si%*%X2, t(X2)%*%Si%*%t(y)); bc2

varbc <- chol2inv(chol((t(X)%*%Si%*%X))); sqrt(diag(varbc))




#-Equilvalent but computationally expensive-#
solve(t(X)%*%solve(S)%*%X)%*%t(X)%*%solve(S)%*%y

#########################
## nlme #################
#########################
library(nlme)
dat <- data.frame(y=as.numeric(y),x=as.numeric(x),lat=M[,1],lon=M[,2])
fit <- gls(y ~ x, data=dat, correlation=corExp(form=~lat+lon,nugget=TRUE))

x0  <- matrix(rnorm(n), ncol=n)
x   <- x0%*%L
y  <- 2*x + rnorm(n)
dat <- data.frame(y=as.numeric(y),x=as.numeric(x),lat=M[,1],lon=M[,2])
fit <- gls(y ~ x, data=dat, correlation=corExp(form=~lat+lon,nugget=FALSE),method='ML')



sp1 <- corSpatial(form = ~ x + y + z, type = "g", metric = "man")
##########################################################
## Variogram #############################################
##########################################################
library(fields)

vg <- vgram(M, t(xp))
plot(vg$d, vg$vg, ylab="gamma", xlab="distance")
lines(vg$centers, vg$stats["mean",], lwd=3, col="red")
plot(vg$centers, vg$stats["mean",], col="red")

vg <- vgram(mat, x, N=12, dmax=300, lon.lat=T)




