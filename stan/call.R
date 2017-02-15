
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

mod_slr  <- stan_model('D:/Dropbox/Teaching/Bayes/DSI/code/simple_linear_regression.stan')

datmp  <- read.csv('D:/Dropbox/Teaching/Bayes/DSI/data/ozone_Riverside_epa.csv')
datmp  <- datmp[complete.cases(cbind(datmp$temp,datmp$Arithmetic.Mean)),]

stan_dat <- list(y=datmp$Arithmetic.Mean[1:200], x=datmp$temp[1:200], N=200)

fit <- sampling(mod_slr, data=stan_dat)
post <- extract(fit)

########################################################
## Plots ###############################################
########################################################
par(mfrow=c(2,2))
plot(seq(-0.1,0.1,length.out=10), rep(0.5,10),type='l',ylim=c(0,4),ylab='',xlab='beta0',bty='n')
	par(new=TRUE); hist(post$beta0,xlim=c(-0.1,0.1),main='',xlab='',ylab='',xaxt='n',yaxt='n',bty='n')
	abline(v=0,lty=2)
plot(seq(-0.001,0.001,length.out=10), rep(0.5,10),type='l',ylim=c(0,4),bty='n',ylab='',xlab='')
	par(new=TRUE); hist(post$beta1,xlim=c(-0.001,0.001),main='',xlab='',ylab='',xaxt='n',yaxt='n',bty='n')
	abline(v=0,lty=2)
plot(seq(0,0.02,length.out=10), rep(0.5,10),type='l',ylim=c(0,4),bty='n',ylab='',xlab='')
	par(new=TRUE); hist(post$sigma,xlim=c(0,0.02),main='',xlab='',ylab='',xaxt='n',yaxt='n',bty='n')
plot(stan_dat$x, stan_dat$y,ylab='y',xlab='x')
lines(seq(30,85),quantile(post$beta0,0.05) + quantile(post$beta1,0.05)*seq(30,85),lty=2)
lines(seq(30,85),quantile(post$beta0,0.50) + quantile(post$beta1,0.50)*seq(30,85),lwd=2)
lines(seq(30,85),quantile(post$beta0,0.95) + quantile(post$beta1,0.95)*seq(30,85),lty=2)

