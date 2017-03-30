rm(list=ls())
setwd('D:/Dropbox/Teaching/Bayes/DSI/Environmental_Stats_with_Stan/Data/')
##################################################################################
## README ########################################################################
##################################################################################
README <- data.frame(
	variable_short=c('lat'),
	variable_long= c('latitude'),
	unit=          c('degree'))
write.table(README,file='README_epa_orange.txt',quote=FALSE,row.names=FALSE,col.names=TRUE,sep=' ')

##################################################################################
## Data Processing ###############################################################
##################################################################################
D  <- read.csv('ozone_orange_epa.csv',header=TRUE,stringsAsFactors=FALSE)
ds <- D[D$Site.Num==7,] 
d  <- data.frame(lat=ds$Latitude,lon=ds$Longitude,
				 n=ds$Observation.Count,
				 year=ds$year,
				 month=ds$month,
				 day=ds$day,
				 ozone_mu=ds$Arithmetic.Mean,
				 ozone_max=ds$X1st.Max.Value,
				 hour_max=ds$X1st.Max.Hour,
				 aqi=ds$AQI,
				 pres=ds$pres,
				 hum=ds$hum,
				 temp=ds$temp,
				 windsp=ds$windsp,
				 winddir=ds$winddir)
d <- d[complete.cases(d),]

write.csv(d,'ozone_orange.csv',row.names=FALSE)
