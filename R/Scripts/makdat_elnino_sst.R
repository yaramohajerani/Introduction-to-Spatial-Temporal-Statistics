rm(list=ls())
setwd('D:/Dropbox/Teaching/Bayes/DSI/Environmental_Stats_with_Stan/Data/')
######################################################################
## makdat elnino time series #########################################
######################################################################
ELNINO     <- read.table('http://www.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/detrend.nino34.ascii.txt',header=TRUE)
elnino_sst <- data.frame(year=ELNINO$YR,
					     month=ELNINO$MON,
						 sst=ELNINO$TOTAL)
write.csv(elnino_sst,'elnino_sst.csv',row.names=FALSE)

##############################################################
## README ####################################################
##############################################################
README <- data.frame(
	variable=c('year', 'month', 'sst'),
	names=   c('year', 'month', 'sea_surface_temperature'),
	units=   c('years','months','degree_celcius'))
write.table(README,'README_elnino_sst.txt',row.names=FALSE,quote=FALSE)