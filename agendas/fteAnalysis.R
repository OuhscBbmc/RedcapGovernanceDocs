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

ouData$Instance[ouData$institution %in% "OUHSC" & ouData$name %in% "Thomas"] <- "BBMC"
ouData$Instance[ouData$institution %in% "OUHSC" & ouData$name %in% "Pravina"] <- "Enterprise"
ouData$Instance[ouData$institution %in% "OUHSC" & ouData$name %in% "TnP"] <- "BBMC+Enterprise"

ggplot(fteData, aes(x=no_fte,y=no_cur_users)) + geom_point(aes(col=factor(OUdat)),show.legend = FALSE) + stat_smooth(method = "loess") + geom_text(aes(label=Instance,color=factor(OUdat)),hjust=.5,vjust=-.5,show.legend = FALSE) + theme_bw() + scale_color_manual(values=c("black","red"))
ggplot(fteData, aes(x=no_fte,y=no_cur_prod_proj)) + geom_point() + stat_smooth(method = "lm")

ggplot(fteData[!fteData$no_fte %in% 10,], aes(x=no_fte,y=no_cur_users,label=Instance)) + geom_point(aes(col=factor(OUdat)),show.legend = FALSE) + stat_smooth(method = "loess") + geom_text(aes(label=Instance,color=factor(OUdat)),hjust=.5,vjust=-.5,show.legend = FALSE) + theme_bw() + scale_color_manual(values=c("black","red"))
ggplot(fteData[!fteData$no_fte %in% 10,], aes(x=no_fte,y=no_cur_prod_proj)) + geom_point(aes(col=factor(OUdat)),show.legend = FALSE) + stat_smooth(method = "loess") + geom_text(aes(label=Instance,color=factor(OUdat)),hjust=.5,vjust=-.5,show.legend = FALSE) + theme_bw() + scale_color_manual(values=c("black","red"))

ggplot(fteData, aes(x=no_fte2,y=no_cur_users,label=Instance)) + geom_point(aes(col=factor(OUdat)),show.legend = FALSE) + stat_smooth(method = "loess") + geom_text(aes(label=Instance,color=factor(OUdat)),hjust=.5,vjust=-.5,show.legend = FALSE) + theme_bw() + scale_color_manual(values=c("black","red"))
ggplot(fteData, aes(x=no_fte2,y=no_cur_prod_proj)) + geom_point(aes(col=factor(OUdat)),show.legend = FALSE) + stat_smooth(method = "loess") + geom_text(aes(label=Instance,color=factor(OUdat)),hjust=.5,vjust=-.5,show.legend = FALSE) + theme_bw() + scale_color_manual(values=c("black","red"))

ggplot(fteData, aes(x=no_cur_prod_proj, y=no_fte)) + 
  geom_point() + 
  geom_vline(xintercept=150, color="purple") +
  stat_smooth(method = "lm") +
  theme_light()
  

g <- ggplot(fteData, aes(x=no_cur_prod_proj, y=no_fte)) + 
  geom_smooth(method = "loess") + 
  geom_point(aes(color=factor(OUdat), fill=factor(OUdat)),show.legend = FALSE, shape=21, size=7) + 
  geom_hline(yintercept=.35, color="tomato"          , alpha=.7) +
  geom_text(data=ouData, mapping=aes(label=Instance), color="tomato",hjust=c(.5, 1.1, -.1), size=5, vjust=2, check_overlap=F, show.legend = FALSE) + 
  scale_x_continuous(labels=scales::comma) + 
  scale_color_manual(values=c("gray20","tomato")) + 
  scale_fill_manual(values=c("#22222222","#EE4422BB")) +
  theme_light() +
  labs(x="Count of Projects in Production", y="Insititution-supported FTE (sum)")

g + geom_vline(xintercept=153, color="tomato", alpha=.7) +
  geom_hline(yintercept=.95, color="blue", alpha=.7) +
  coord_cartesian(xlim=c(-150, 1300))

ggsave("project-count.png", width=7, height=5, units="in")

g + aes(x=no_cur_users) +
  geom_hline(yintercept=.87, color="blue", alpha=.7) +
  geom_vline(xintercept=411, color="tomato", alpha=.7) + 
  coord_cartesian(xlim=c(-250, 2800)) + 
  labs(x="Count of Users")

ggsave("user-count.png", width=7, height=5, units="in")
