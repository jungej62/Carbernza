library(reshape); library(ggplot2)
soildat<-read.csv("C:/Users/junge037/Google Drive/Carbernza/Analysis/IREEsoil.csv")
head(soildat)
#OM and TOC as %, BD as g/cm3, NO3 and NH4 as ppm
summarySE(soildat, measurevar="toc", groupvars="location", na.rm=T)

tocom<-soildat[,c(1,2,4:8,11)]
tocom$Nfert<-factor(tocom$Nfert)
tocom$plot<-factor(tocom$plot)
tocom$year<-factor(tocom$year)
#tocomw<-melt(tocom, id=c("location","var","Nfert", "plot", "depth", variable="year", value=c("toc", "om")))
tocomw<-dcast(tocom, location+var+Nfert+plot+depth~year, value.var="om", mean)
tocomw<-tocomw[,c(1,2,3,4,5,6,9)]
names(tocomw)[6:7]<-c("preOM", "postOM")
tocomw2<-cbind(tocomw,dcast(tocom, location+var+Nfert+plot+depth~year, value.var="toc", mean)[,c(6,9)] )
names(tocomw2)[8:9]<-c("preTOC","postTOC")
tocomw2[tocomw2=="NaN"]<-NA
tocomw2$difOM<-tocomw2$postOM-tocomw2$preOM
tocomw2$difTOC<-tocomw2$postTOC-tocomw2$preTOC

#This is an analysis of the 0 N treatments only. If we assume that the pre TOC values were the same for all N treatments
#before the application of N, we can expand this analysis.
sumtocom<-summarySE(tocomw2, measurevar="difTOC", groupvars=c("location", "var", "depth"), na.rm=T)

ggplot(sumtocom, aes(x=var, y=difTOC, fill=depth))+
  facet_grid(~location)+
  geom_bar(stat="identity", position="dodge")+
  geom_errorbar(aes(ymax=difTOC+se, ymin=difTOC-se), position="dodge")


sumom<-summarySE(tocomw2, measurevar="difOM", groupvars=c("location", "var", "depth"), na.rm=T)

ggplot(sumom, aes(x=var, y=difOM, fill=depth))+
  facet_grid(~location)+
  geom_bar(stat="identity", position="dodge")+
  geom_errorbar(aes(ymax=difOM+se, ymin=difOM-se), position="dodge")

#Now check to see if the pre-levels were the same acrosss crops within each depth/location
bgdat<-soildat[,c(1,2,4:8,11:15)]
bgdat$Nfert<-factor(bgdat$Nfert)
bgdat$plot<-factor(bgdat$plot)
bgdat$year<-factor(bgdat$year)
bgdat2<-cbind(tocomw2[,c(1:6,8)], dcast(bgdat, location+var+Nfert+plot+depth~year, value.var="density", mean)[,6] )
names(bgdat2)[8]<-"BD"
head(bgdat2)
#Comparing BD across varieties within locations and depths
summarySE(bgdat2, measurevar="BD", groupvars=c("location", "var", "depth"), na.rm=T)
anova(lm(BD~var*location*depth, data=bgdat2)) #no difference in bulk density
anova(lm(BD~var, data=subset(bgdat2, location=="Was"&depth=="C"))) #can check by location/depth
#Comparing preTOC across varieties within locations and depths
summarySE(bgdat2, measurevar="preTOC", groupvars=c("location", "var", "depth"), na.rm=T)
anova(lm(preTOC~var*location*depth, data=bgdat2)) #no difference in preTOC by variety
anova(lm(BD~var, data=subset(bgdat2, location=="Was"&depth=="C"))) #can check by location/depth
#Comparing preOM across varieties within locations and depths
summarySE(bgdat2, measurevar="preOM", groupvars=c("location", "var", "depth"), na.rm=T)
anova(lm(preOM~var*location*depth, data=bgdat2)) #no difference in preOM by variety

#summary of BD, TOC, and OM by depth for each location regardless of N and crop
#TOC is a percent C, and BD is g/cm3
bgdat2$Carbon<-bgdat2$BD*bgdat2$preTOC*0.01 #to convert % (g/100g) to grams C per gram soil 
head(bgdat2)
#converting to g/m2 per depth
#0-6 inches is 15.2 cm deep. Multiply by 10000 because there is 10000 square cm in a square meter
bgdat2$Carbon2<-bgdat2$Carbon*152000 #15.2 cm deep time 10000 cm2 per meter2
head(bgdat2)
bgdat2[bgdat2=="NaN"]<-NA

bgdat3<-dcast(bgdat2, location~depth, value.var="Carbon2", mean, na.rm=T)
bgdat3 #Show those means by depth and location
bgdat3$TotalC<-bgdat3$A+bgdat3$B #Total C in grams per m2 down to 30 cm.
#DayCent models down to 20 cm.
