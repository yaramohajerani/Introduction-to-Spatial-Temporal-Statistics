rm(list=ls())
library(nlme)
################################################################################
## analysis_EPA_orange #########################################################
################################################################################
d <- read.csv('D:/Dropbox/Teaching/Bayes/DSI/Environmental_Stats_with_Stan/Data/ozone_orange.csv',stringsAsFactors=FALSE)

pairs(d[,4:ncol(d)], lower.panel=panel.smooth, 
					 upper.panel=panel.cor,
					 diag.panel=panel.hist,
					 pch=19,col=adjustcolor('black',alpha.f=0.01))

######################################
## Time series #######################
######################################
oz  <- d$ozone_mu
ozm <- d$ozone_max
aqi <- d$aqi


plot(oz)

######################################
## Regression ########################
######################################
summary(gls(ozone_mu ~ temp,data=d,correlation=corAR1()))

summary(gls(ozone_mu ~ year,data=d,correlation=corAR1()))


summary(lm(ozone_mu ~ temp + year, data=d))


nyears <- max(d$year) - min(d$year)
summary(lm(ozone_mu ~ temp + year, data=d))

