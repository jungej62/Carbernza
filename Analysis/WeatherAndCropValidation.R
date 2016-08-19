library("XML");library(spatialEco); library(plyr)
require(devtools); require(latticeExtra); library(hydroGOF)
install_github("khufkens/daymetr") # install the package
require(DaymetR)

setwd("C:/Users/junge037/Desktop/")
dat<-read.table("CrookLng.txt")
#dat[dat==-99.900]<-NA
head(dat)
colnames(dat)<-c("day","month","year","doy","maxtmp","mintmp","precip")

#First leap year would be in 1892
yrs<-seq(from=1892, to=max(dat$year), by=4)
leaps<-data.frame("day"=rep(29,length(yrs)),
                  "month"=rep(2,length(yrs)),
                  "year"=yrs,
                  "doy"=NA,
                  "maxtmp"=-99.9,
                  "mintmp"=-99.9,
                  "precip"=-99.9)
dat2<-rbind(dat, leaps)
dat3<-arrange(dat2, year, month, day)
#dat3$doy2<-c(rep(1:365,2),rep(c(1:366,rep(1:365,3)),length(leaps$day)))
dat3$doy2<-NA
for(i in 1:length(dat3$day)){
  if(dat3[i,1]==1&dat3[i,2]==1){
    dat3[i,8]<-1
  }else{
    dat3[i,8]<-dat3[i-1,8]+1
  }
}

dat4<-data.frame(dat3[,1:3],dat3[,8],dat3[,5:7])
write.table(dat4, file="CrookLg2", row.names=F, col.names=F, sep="\t")


summary(dat4$precip)

summary(dat$mintmp)
summary(dat$maxtmp)
summary(dat$precip)
hist(dat$precip)
hist(dat$mintmp)
hist(dat$maxtmp)


cldat<-readHTMLTable("https://daymet.ornl.gov/single-pixel/send/query?daacid=37892&lat=47.811&lon=-96.603&measuredParams=tmax%2Ctmin%2Cdayl%2Cprcp%2Csrad%2Cswe%2Cvp&year=1980%2C1981%2C1982%2C1983%2C1984%2C1985%2C1986%2C1987%2C1988%2C1989%2C1990%2C1991%2C1992%2C1993%2C1994%2C1995%2C1996%2C1997%2C1998%2C1999%2C2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015", which=1)
cldat<-download.daymet(site="StCloud",lat= 45.557,lon= -94.161,start_yr=1981,end_yr=2009,internal=TRUE)
cldat<-daymet.point(lat=45.557, long=-94.161, start.year=1990, end.year=1991, site="Crookston")
d <- daymet.point(lat = 36.0133, long = -84.2625, start.year = 2010, end.year=2011,
                    site = "1", files = FALSE, echo = FALSE)

hay<-read.csv("C:/Users/junge037/Documents/USDA_NIFA/PostApproval/DayCent/PolkCountyHayAcreageYield.csv")
plot(hay[,1], hay[,9])
names(hay)<-c("year","location","X1","X2","X3","X4","type","practice","area","production","yield")
summary(hay$area)
xyplot(area~year, data=hay, groups=type)
xyplot(yield~year, data=hay, groups=type)

barley<-read.csv("C:/Users/junge037/Documents/USDA_NIFA/PostApproval/DayCent/PolkCountyBarley.csv")
plot(barley$year, barley$area)

wheat<-read.csv("C:/Users/junge037/Documents/USDA_NIFA/PostApproval/DayCent/PolkCountyWheat.csv")
plot(wheat$year, wheat$area)
xyplot(area~year, data=wheat, groups=type)

soybean<-read.csv("C:/Users/junge037/Documents/USDA_NIFA/PostApproval/DayCent/PolkCountySoybean.csv")
plot(soybean$year, soybean$area)

corn<-read.csv("C:/Users/junge037/Documents/USDA_NIFA/PostApproval/DayCent/PolkCountyCorn.csv")
xyplot(area~year, data=corn, groups=type)
xyplot(yield~year, data=corn, groups=type)

conven1<-read.csv("C:/Users/junge037/Google Drive/Carbernza/Analysis/conven-output.csv")
xyplot(bushyld~year, data=conven1, groups=crop, auto.key=T)

#Validation... really good!

conven1<-read.csv("C:/Users/junge037/Google Drive/Carbernza/Analysis/conven-output.csv")


corndat<-droplevels(subset(conven1, crop=="corn"))
zzz<-droplevels(subset(corn, type=="CORN, GRAIN"))
zzz<-zzz[zzz$year %in% corndat$year,]
names(zzz)[ncol(zzz)]<-c("bushyld") #renaming last column bushyld
corndat2<-rbind(corndat[,c("year", "bushyld")],
                zzz[,c("year", "bushyld")])
corndat2$type<-c(rep("model",length(corndat$year)), 
                 rep("real",length(zzz$year)))
xyplot(bushyld~year, corndat2, groups=type, auto.key=T)
rmse(corndat$bushyld, zzz$bushyld)


wheatdat<-droplevels(subset(conven1, crop=="wheat"))
zzz<-droplevels(subset(wheat, crop=="WHEAT, SPRING, (EXCL DURUM)"))
zzz<-zzz[zzz$year %in% wheatdat$year,]
names(zzz)[ncol(zzz)]<-c("bushyld") #renaming last column bushyld
wheatdat2<-rbind(wheatdat[,c("year", "bushyld")],
                zzz[,c("year", "bushyld")])
wheatdat2$type<-c(rep("model",length(wheatdat$year)), 
                 rep("real",length(zzz$year)))
xyplot(bushyld~year, wheatdat2, groups=type, auto.key=T)
rmse(subset(wheatdat, year>"1920")$bushyld, zzz$bushyld)

soydat<-droplevels(subset(conven1, crop=="soy"))
zzz<-soybean
zzz<-zzz[zzz$year %in% soydat$year,]
names(zzz)[ncol(zzz)]<-c("bushyld") #renaming last column bushyld
soydat2<-rbind(soydat[,c("year", "bushyld")],
                zzz[,c("year", "bushyld")])
soydat2$type<-c(rep("model",length(soydat$year)), 
                 rep("real",length(zzz$year)))
xyplot(bushyld~year, soydat2, groups=type, auto.key=T)
rmse(soydat$bushyld, zzz$bushyld)
