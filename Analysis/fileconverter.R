#Script for converting cgrain information to yield data
library(stringr); library(plyr)
#decoding data frame
cropcodes<-data.frame("crpval"=c(21.3, 42.1, 42.2, 36.2, 26.0, 42.3, 60.2, 21.2, 3.1, 60.0, 39),
                      "crop"=c("prairie", "wheat", "wheat", "oat", "pasture", "wheat", "soy", "barley","corn","soy","kernza"),
                      "moisture"=c(NA, 0.135, 0.135, 0.14, NA, 0.135, 0.13, 0.145, 0.155, 0.13, 0.13),
                      "carbon"=c(NA, 0.46, 0.46, 0.46, NA, 0.46, 0.54, 0.48, 0.45, 0.54, 0.45),
                      "bushelwt"=c(NA, 60, 60, 32, NA, 60, 60, 48, 56, 60, 60))

testdat<-read.table("C:/Users/junge037/Google Drive/Carbernza/kernza2.lis", header=T)
unique(testdat$crpval)
head(testdat)
testdat$year<-as.numeric(substr(testdat$time, 1, 4))
testdat$month<-as.numeric(substr(testdat$time, 5, 7))
testdat$month[is.na(testdat$month)]<-0
head(testdat)
ttt<-cbind(testdat, str_split_fixed(testdat$time,"\\.", 2))
names(ttt)[c(ncol(ttt)-1, ncol(ttt))]<-c("year","month")
head(ttt)

ttt<-merge(ttt, cropcodes, by="crpval")
ttt$gmyld<-ttt$cgrain/ttt$carbon
ttt$lbsyld<-ttt$gmyld*(1+ttt$moisture)*8.92
ttt$bushyld<-ttt$lbsyld/ttt$bushelwt
ttt<-arrange(ttt, year, month)
newttt<-subset(ttt, month=="83")
write.csv(newttt, "C:/Users/junge037/Google Drive/Carbernza/Analysis/test-output.csv", row.names=F)

converter<-function(filename){
  dat<-read.table(paste("C:/Users/junge037/Google Drive/Carbernza/",filename,".lis", sep=""), header=T)
  dat$year<-as.numeric(substr(dat$time, 1, 4))
  dat$month<-as.numeric(substr(dat$time, 5, 7))
  dat$month[is.na(dat$month)]<-0
  dat<-merge(dat, cropcodes, by="crpval") #adding crop names and grain characteristics to output from data table above
  dat$gmyld<-dat$cgrain/dat$carbon #calculating grain yield in grams per square meter
  dat$lbsyld<-dat$gmyld*(1+dat$moisture)*8.92 #converting grams/m2 yield to lbs per acre with correct moisture content
  dat$bushyld<-dat$lbsyld/dat$bushelwt #converting lbs/acre at proper moisture to bushels per acre
  write.csv(dat, paste("C:/Users/junge037/Google Drive/Carbernza/Analysis/",filename,"-output.csv",
                        sep=""), row.names=F )
}

converter("conven")
converter("kernza2")


