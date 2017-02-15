rm(list=ls())

setwd('D:/Dropbox/DATA/EPA/')

files_oz 	<- list.files('ozone/')[grep("daily", list.files('ozone/'))]
files_pres 	<- list.files('pressure/')[grep("daily", list.files('pressure/'))]
files_hum  	<- list.files('humidity/')[grep("daily", list.files('humidity/'))]
files_temp 	<- list.files('temperature/')[grep("daily", list.files('temperature/'))]
files_wind 	<- list.files('wind/')[grep("daily", list.files('wind/'))]

state <- 'California'
#county <- 'Orange'
#county <- 'Santa Barbara'
county <- 'Riverside'

####################################################################
## Loop through annual files #######################################
####################################################################
dat <- data.frame()

for(i in 1:length(files_oz)){ 
print(i)

	dat_oz 	  		   <- read.csv(paste('ozone/',files_oz[i],sep=''),stringsAsFactors=FALSE)
	dat_ozI   	       <- dat_oz[dat_oz$State.Name==state & dat_oz$County.Name==county,] 
		dat_ozI$year   <- unlist(lapply(strsplit(dat_ozI$Date.Local,'-'), `[[`, 1)) 
		dat_ozI$month  <- unlist(lapply(strsplit(dat_ozI$Date.Local,'-'), `[[`, 2)) 
		dat_ozI$day    <- unlist(lapply(strsplit(dat_ozI$Date.Local,'-'), `[[`, 3)) 	

	dat_pres  	  	   <- read.csv(paste('pressure/',files_pres[i],sep=''),stringsAsFactors=FALSE)
	dat_pres 		   <- dat_pres[dat_pres$State.Name==state & dat_pres$County.Name==county,]
		dat_pres$year  <- unlist(lapply(strsplit(dat_pres$Date.Local,'-'), `[[`, 1)) 
		dat_pres$month <- unlist(lapply(strsplit(dat_pres$Date.Local,'-'), `[[`, 2)) 
		dat_pres$day   <- unlist(lapply(strsplit(dat_pres$Date.Local,'-'), `[[`, 3)) 

	dat_hum	           <- read.csv(paste('humidity/',files_hum[i],sep=''),stringsAsFactors=FALSE)
	dat_hum            <- dat_hum[dat_hum$State.Name==state & dat_hum$County.Name==county,]
		dat_hum$year   <- unlist(lapply(strsplit(dat_hum$Date.Local,'-'), `[[`, 1)) 
		dat_hum$month  <- unlist(lapply(strsplit(dat_hum$Date.Local,'-'), `[[`, 2)) 
		dat_hum$day    <- unlist(lapply(strsplit(dat_hum$Date.Local,'-'), `[[`, 3)) 

	dat_temp           <- read.csv(paste('temperature/',files_temp[i],sep=''),stringsAsFactors=FALSE)
	dat_temp 		   <- dat_temp[dat_temp$State.Name==state & dat_temp$County.Name==county,]
		dat_temp$year  <- unlist(lapply(strsplit(dat_temp$Date.Local,'-'), `[[`, 1)) 
		dat_temp$month <- unlist(lapply(strsplit(dat_temp$Date.Local,'-'), `[[`, 2)) 
		dat_temp$day   <- unlist(lapply(strsplit(dat_temp$Date.Local,'-'), `[[`, 3)) 

	dat_wind           <- read.csv(paste('wind/',files_wind[i],sep=''),stringsAsFactors=FALSE)
	dat_wind           <- dat_wind[dat_wind$State.Name==state & dat_wind$County.Name==county,]
		dat_wind$year  <- unlist(lapply(strsplit(dat_wind$Date.Local,'-'), `[[`, 1)) 
		dat_wind$month <- unlist(lapply(strsplit(dat_wind$Date.Local,'-'), `[[`, 2)) 
		dat_wind$day   <- unlist(lapply(strsplit(dat_wind$Date.Local,'-'), `[[`, 3)) 	
	
	###################################################################
	## Attach environmental observations to ozone #####################
	###################################################################	
	for(j in 1:nrow(dat_ozI)){
	
		site  <- dat_ozI$Site.Num[j]
		year  <- dat_ozI$year[j]	
		month <- dat_ozI$month[j]	
		day   <- dat_ozI$day[j]		

		pres <-  dat_pres$Arithmetic.Mean[dat_pres$Site.Num==site & dat_pres$year==year & dat_pres$month==month & dat_pres$day==day]
			dat_ozI$pres[j] <- ifelse(length(pres)>0,pres,NA)		
		hum  <-  dat_hum$Arithmetic.Mean[dat_hum$Site.Num==site & dat_hum$year==year & dat_hum$month==month & dat_hum$day==day]
			dat_ozI$hum[j] <- ifelse(length(hum)>0,hum,NA)		
		temp <- dat_temp$Arithmetic.Mean[dat_temp$Site.Num==site & dat_temp$year==year & dat_temp$month==month & dat_temp$day==day]
			dat_ozI$temp[j] <- ifelse(length(temp)>0,temp,NA)		
		wind <- dat_wind$Arithmetic.Mean[dat_wind$Site.Num==site & dat_wind$year==year & dat_wind$month==month & dat_wind$day==day]
			dat_ozI$windsp[j]  <- ifelse(length(wind[1])>0,wind[1],NA)
			dat_ozI$winddir[j] <- ifelse(length(wind[2])>0,wind[2],NA)
	}	
	dat <- rbind(dat,dat_ozI)
}

#####################################################
## Write files to disk ##############################
#####################################################
write.csv(dat,file=paste('D:/Dropbox/Teaching/Bayes/DSI/data/ozone_',county,'_epa.csv',sep=''))







