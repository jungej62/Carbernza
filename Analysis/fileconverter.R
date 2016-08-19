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
  dat<-cbind(dat, str_split_fixed(dat$time,"\\.", 2))
  names(dat)[c(ncol(dat)-1, ncol(dat))]<-c("year","month")
  dat<-merge(dat, cropcodes, by="crpval") #adding crop names and grain characteristics to output from data table above
  dat$gmyld<-dat$cgrain/dat$carbon #calculating grain yield in grams per square meter
  dat$lbsyld<-dat$gmyld*(1+dat$moisture)*8.92 #converting grams/m2 yield to lbs per acre with correct moisture content
  dat$bushyld<-dat$lbsyld/dat$bushelwt #converting lbs/acre at proper moisture to bushels per acre
  dat2<-subset(dat, month=="83")
  write.csv(dat2, paste("C:/Users/junge037/Google Drive/Carbernza/Analysis/",filename,"-output.csv",
                        sep=""), row.names=F )
}

converter("conven")
converter("kernza2")
