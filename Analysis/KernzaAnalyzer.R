
kdat<-read.csv("C:/Users/junge037/Google Drive/Carbernza/Analysis/kernza2-output.csv")
kdat<-arrange(kdat, time)
head(kdat)
kdat<-subset(kdat, time!=1)
plot(kdat$somtc~kdat$time)
xyplot(somtc~time, data=subset(kdat, time>1925), type='b')
xyplot(somtc~time, data=subset(kdat, time>2000), type='b')
