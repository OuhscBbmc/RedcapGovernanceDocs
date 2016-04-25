#inpsect relationship between RC use and supported FTE
library(ggplot2)

fteData <- read.csv("./agendas/fteData.csv")
hipaaData <- read.csv("./agendas/breach_report.csv")
table(hipaaData$Covered.Entity.Type)
table(hipaaData$Location.of.Breached.Information)
grep("research",hipaaData$Location.of.Breached.Information,ignore.case = TRUE,value = TRUE)

ouData <- data.frame(list(c("Thomas","Pravina","TnP"),rep("OUHSC",3),c(.1,.25,.35),c(303,108,411),c(106,47,153)))
colnames(ouData) <- colnames(fteData)

fteData <- rbind(fteData,ouData)
fteData$no_fte2 <- ifelse(fteData$no_fte <= 2,fteData$no_fte,2)


fteData$OUdat <- (fteData$institution %in% "OUHSC")
fteData$Instance <- ""
fteData$Instance[fteData$institution %in% "OUHSC" & fteData$name %in% "Thomas"] <- "BBMC"
fteData$Instance[fteData$institution %in% "OUHSC" & fteData$name %in% "Pravina"] <- "Enterprise"
fteData$Instance[fteData$institution %in% "OUHSC" & fteData$name %in% "TnP"] <- "BBMC+Enterprise"

ggplot(fteData, aes(x=no_fte,y=no_cur_users)) + geom_point(aes(col=factor(OUdat)),show.legend = FALSE) + stat_smooth(method = "loess") + geom_text(aes(label=Instance,color=factor(OUdat)),hjust=.5,vjust=-.5,show.legend = FALSE) + theme_bw() + scale_color_manual(values=c("black","red"))
ggplot(fteData, aes(x=no_fte,y=no_cur_prod_proj)) + geom_point() + stat_smooth(method = "lm")

ggplot(fteData[!fteData$no_fte %in% 10,], aes(x=no_fte,y=no_cur_users,label=Instance)) + geom_point(aes(col=factor(OUdat)),show.legend = FALSE) + stat_smooth(method = "loess") + geom_text(aes(label=Instance,color=factor(OUdat)),hjust=.5,vjust=-.5,show.legend = FALSE) + theme_bw() + scale_color_manual(values=c("black","red"))
ggplot(fteData[!fteData$no_fte %in% 10,], aes(x=no_fte,y=no_cur_prod_proj)) + geom_point(aes(col=factor(OUdat)),show.legend = FALSE) + stat_smooth(method = "loess") + geom_text(aes(label=Instance,color=factor(OUdat)),hjust=.5,vjust=-.5,show.legend = FALSE) + theme_bw() + scale_color_manual(values=c("black","red"))

ggplot(fteData, aes(x=no_fte2,y=no_cur_users,label=Instance)) + geom_point(aes(col=factor(OUdat)),show.legend = FALSE) + stat_smooth(method = "loess") + geom_text(aes(label=Instance,color=factor(OUdat)),hjust=.5,vjust=-.5,show.legend = FALSE) + theme_bw() + scale_color_manual(values=c("black","red"))
ggplot(fteData, aes(x=no_fte2,y=no_cur_prod_proj)) + geom_point(aes(col=factor(OUdat)),show.legend = FALSE) + stat_smooth(method = "loess") + geom_text(aes(label=Instance,color=factor(OUdat)),hjust=.5,vjust=-.5,show.legend = FALSE) + theme_bw() + scale_color_manual(values=c("black","red"))
