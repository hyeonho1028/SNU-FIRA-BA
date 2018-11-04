##### SkillCraft 별로 탐색적 자료분석 #####
##### 나는 탐색적 자료분석을 왜 했다. 뭘 알아냈다 #####
# 이상치들 변수에 따라서 등급이 어떻게 떨어지는가, 산점도 등급에따라서 다르게 색을
if(!require(dplyr)){install.packages("dplyr"); library(dplyr)}

SkillCraft = read.csv("C:/workspace/R/6/data/SkillCraft1_Dataset.csv")

##### basic table #####
dim(SkillCraft)
names(SkillCraft)
str(SkillCraft)
attach(SkillCraft)
name <- c("Bronze", "Silver", "Gold", "Platinum", "Diamond", "Master",
          "GrandMaster", "Professional")
# detach, attach의 반대 전역변수를 다시 지역변수로 바꿔준다 정도

# 연습 ----
head(SkillCraft)
my.table <- xtabs(~LeagueIndex+Age, SkillCraft, drop=F)
barplot( my.table,
         xlab = "Improved", ylab = "Frequency", legend.text = TRUE,
         col = rainbow(8)  , horiz=T)


bar<-ggplot(SkillCraft, aes(x=Age, y=c(0, 10), fill=LeagueIndex))
bar+geom_bar(stat="identity", position="fill")
?barplot


names(my.table)






##### gameId #####
summary(GameID)
length(GameID %>% unique()) == nrow(SkillCraft)
# gameId는 고유하다.

##### LeagueIndex #####
summary(LeagueIndex)
table(LeagueIndex)
barplot(table(LeagueIndex), main = "LeagueIndex Chart", 
        xlab = "tear", ylab = "freq", col = 'lightblue', names.arg = name)

##### Age #####
str(Age)
summary(Age)
barplot(table(Age), main = 'Age')

# 범주형 변수의 levels를 제거 할대 쓰는 방법임..
# SkillCraft=SkillCraft[SkillCraft$Age != '?',]
# # '?'를 갖는 age제거
# SkillCraft$Age <- droplevels(SkillCraft$Age)

par(mfrow=c(4,2))
for (i in 1:8)
{
  barplot(table(Age[LeagueIndex == i]), main = name[i], col = 'lightblue')
}


##### HoursPerWeek #####
str(HoursPerWeek)
HoursPerWeek <- as.numeric(HoursPerWeek)
str(HoursPerWeek)
boxplot(HoursPerWeek)
boxplot(HoursPerWeek~LeagueIndex, names = name, main = "HoursPerWeek")

par(mfrow=c(4,2))
for (i in 1:8)
{
  if (i == 4 | i == 5 | i == 7)
  {
    hist(HoursPerWeek[LeagueIndex == i], col = 'lightblue',
        main = 'HoursPerWeek', xlab = name[i], xlim = c(0, 35), 
        border = 'white', probability = T, breaks = 20)    
    lines(density(HoursPerWeek[LeagueIndex == i]),col = 'red', lwd = 2)
  }
  else
  {
    hist(HoursPerWeek[LeagueIndex == i], col = 'lightblue',
        main = 'HoursPerWeek', xlab = name[i], xlim = c(0, 35), 
        border = 'white', probability = T)
    lines(density(HoursPerWeek[LeagueIndex == i]),col = 'red', lwd = 2)
  }
}

##### TotalHours #####
str(TotalHours)
TotalHours <- as.numeric(TotalHours)
str(TotalHours)
boxplot(HoursPerWeek)
boxplot(TotalHours~LeagueIndex, names = name, main = "TotalHours")

par(mfrow=c(4,2))
for (i in 1:8)
{
  hist(TotalHours[LeagueIndex == i], col = 'lightblue',
       main = 'TotalHours', xlab = name[i], xlim = c(0, 250),
       border = 'white')
  #lines(density(TotalHours[LeagueIndex == i]),col = 'red', lwd = 2)
}

##### APM #####
str(APM)
boxplot(APM)
boxplot(APM~LeagueIndex, names = name, main = "APM")

par(mfrow=c(4,2))
for (i in 1:8)
{
  hist(APM[LeagueIndex == i], col = 'lightblue',
       main = 'APM', xlab = name[i], xlim = c(0, 400), ylim = c(0,0.02),
       border = 'white', probability = T)
  lines(density(APM[LeagueIndex == i]),col = 'red', lwd = 2)
}

##### SelectByHotkeys #####
str(SelectByHotkeys)
boxplot(SelectByHotkeys)
boxplot(SelectByHotkeys~LeagueIndex, names = name, main = "SelectByHotkeys")

par(mfrow = c(4,2))
for ( i in 1:8)
{
  hist(SelectByHotkeys[LeagueIndex == i], col = 'lightblue',
       main = 'SelectByHotkeys', xlab = name[i], xlim = c(0, 0.05),
       border = 'white')
}

##### AssignToHotkeys #####
str(AssignToHotkeys)
boxplot(AssignToHotkeys)
boxplot(AssignToHotkeys~LeagueIndex, names = name, main = "AssignToHotkeys")

par(mfrow = c(4,2))
for ( i in 1:8 )
{
  hist(AssignToHotkeys[LeagueIndex == i], col = 'lightblue',
       main = 'AssignToHotkeys', xlab = name[i], xlim = c(0, 0.0020),
       border = 'white')
}

##### UniqueHotkeys #####
str(UniqueHotkeys)
boxplot(UniqueHotkeys)
boxplot(UniqueHotkeys~LeagueIndex, names = name, main = "UniqueHotkeys")

##### MinimapAttacks #####
str(MinimapAttacks)
boxplot(MinimapAttacks)
boxplot(MinimapAttacks~LeagueIndex, names = name, main = "MinimapAttacks")

##### MinimapRightClicks #####
str(MinimapRightClicks)
boxplot(MinimapRightClicks)
boxplot(MinimapRightClicks~LeagueIndex, names = name, main = "MinimapRightClicks")

##### NumberOfPACs #####
str(NumberOfPACs)
boxplot(NumberOfPACs)
boxplot(NumberOfPACs~LeagueIndex, names = name, main = "NumberOfPACs")

##### GapBetweenPACs #####
str(GapBetweenPACs)
boxplot(GapBetweenPACs)
boxplot(GapBetweenPACs~LeagueIndex, names = name, main = "GapBetweenPACs")

##### ActionLatency #####
str(ActionLatency)
boxplot(ActionLatency)
boxplot(ActionLatency~LeagueIndex, names = name, main = "ActionLatency")

par(mfrow = c(4,2))
for ( i in 1:8)
{
  hist(ActionLatency[LeagueIndex == i], col = 'lightblue',
       main = 'ActionLatency', xlab = name[i], xlim = c(0, 180),
       border = 'white', probability = T)
  lines(density(ActionLatency[LeagueIndex == i]),col = 'red', lwd = 2)
}

##### ActionsInPAC #####
str(ActionsInPAC)
boxplot(ActionsInPAC)
boxplot(ActionsInPAC~LeagueIndex, names = name, main = "ActionsInPAC")

##### TotalMapExplored #####
str(TotalMapExplored)
boxplot(TotalMapExplored)
boxplot(TotalMapExplored~LeagueIndex, names = name, main = "TotalMapExplored")

##### WorkersMade #####
str(WorkersMade)
boxplot(WorkersMade)
boxplot(WorkersMade~LeagueIndex, names = name, main = "WorkersMade")

##### UniqueUnitsMade #####
str(UniqueUnitsMade)
boxplot(UniqueUnitsMade)
boxplot(UniqueUnitsMade~LeagueIndex, names = name, main = "UniqueUnitsMade")

##### ComplexUnitsMade #####
str(ComplexUnitsMade)
boxplot(ComplexUnitsMade)
boxplot(ComplexUnitsMade~LeagueIndex, names = name, main = "ComplexUnitsMade")

##### ComplexAbilitiesUsed #####
str(ComplexAbilitiesUsed)
boxplot(ComplexAbilitiesUsed)
boxplot(ComplexAbilitiesUsed~LeagueIndex, names = name, main = "ComplexAbilitiesUsed")

par(mfrow = c(4,2))
for ( i in 1:8)
{
  hist(ComplexAbilitiesUsed[LeagueIndex == i], col = 'lightblue',
       main = 'ActionLatency', xlab = name[i], xlim = c(0, 0.0030), ylim = c(0, 20000),
       border = 'white', probability = T)
  lines(density(ComplexAbilitiesUsed[LeagueIndex == i]),col = 'red', lwd = 2)
}


##### randomForest #####
if(!require(randomForest)){install.packages("randomForest"); library(randomForest)}

SkillCraft = read.csv("C:/workspace/R/6/data/SkillCraft1_Dataset.csv")
SkillCraft <- select(SkillCraft, -c(GameID, Age))
str(SkillCraft)
SkillCraft$HoursPerWeek <- as.numeric(SkillCraft$HoursPerWeek)
SkillCraft$TotalHours <- as.numeric(SkillCraft$TotalHours)

?randomForest
# 랜덤포레스트의 경우 범주형변수의 레벨을 32개 이하로 제한하고 있다.
# 범주형 변수 제거와 변경

a = SkillCraft[LeagueIndex == 1 | LeagueIndex == 2,]
b = SkillCraft[LeagueIndex == 2 | LeagueIndex == 3,]
c = SkillCraft[LeagueIndex == 3 | LeagueIndex == 4,]
d = SkillCraft[LeagueIndex == 4 | LeagueIndex == 5,]
e = SkillCraft[LeagueIndex == 5 | LeagueIndex == 6,]
f = SkillCraft[LeagueIndex == 6 | LeagueIndex == 7,]
g = SkillCraft[LeagueIndex == 7 | LeagueIndex == 8,]



ma <- randomForest(LeagueIndex~., data = a)
im1 <- importance(ma)
mb <- randomForest(LeagueIndex~., data = b)
im2 <- importance(mb)
mc <- randomForest(LeagueIndex~., data = c)
im3 <- importance(mc)
md <- randomForest(LeagueIndex~., data = d)
im4 <- importance(md)
me <- randomForest(LeagueIndex~., data = e)
im5 <- importance(me)
mf <- randomForest(LeagueIndex~., data = f)
im6 <- importance(mf)
mg <- randomForest(LeagueIndex~., data = g)
im7 <- importance(mg)


##### ggplot #####
if(!require(ggplot2)){install.packages("ggplot2"); library(ggplot2)}

im1 <- data.frame(im1)
im2 <- data.frame(im2)
im3 <- data.frame(im3)
im4 <- data.frame(im4)
im5 <- data.frame(im5)
im6 <- data.frame(im6)
im7 <- data.frame(im7)

order(im11$value)
im1 <- cbind(im1, as.data.frame(rep('bronze ~ silver',17)), rownames(im1))
colnames(im1) <-  c('val1','val2','val3')
im2 <- cbind(im2, as.data.frame(rep('silver ~ gold',17)), rownames(im2))
colnames(im2) <-  c('val1','val2','val3')
im3 <- cbind(im3, as.data.frame(rep('gold ~ platinum',17)), rownames(im3))
colnames(im3) <-  c('val1','val2','val3')
im4 <- cbind(im4, as.data.frame(rep('platinum ~ diamond',17)), rownames(im4))
colnames(im4) <-  c('val1','val2','val3')
im5 <- cbind(im5, as.data.frame(rep('diamond ~ master',17)), rownames(im5))
colnames(im5) <-  c('val1','val2','val3')
im6 <- cbind(im6, as.data.frame(rep('master ~ grandmaster',17)), rownames(im6))
colnames(im6) <-  c('val1','val2','val3')
im7 <- cbind(im7, as.data.frame(rep('grandmaster ~ Professional',17)), rownames(im7))
colnames(im7) <-  c('val1','val2','val3')

u <- rbind(im1, im2, im3, im4, im5, im6, im7)


ggplot(u, aes(val2, val3))+
  geom_raster(aes(fill = val1))+
  labs(title ="Heat Map", x = "Outlet Identifier", y = "Item Type")+
  scale_fill_continuous(name = "Item MRP")

ggplot(data = u, aes(x=val2, y=val3))+
  geom_tile(aes(fill = val1), colour = "white")+
  scale_fill_gradient(low = "white", high = "steelblue")
    



ggplot(train, aes(Outlet_Identifier, Item_Type))+
  geom_raster(aes(fill = Item_MRP))+
  labs(title ="Heat Map", x = "Outlet Identifier", y = "Item Type")+
  scale_fill_continuous(name = "Item MRP")



install.packages("corrgram")
library(corrgram)
corrgram(train, order=NULL,
           panel=panel.shade, text.panel=panel.txt,
           main="Correlogram")




ggplot(economics) + geom_rect(aes(xmin = start,xmax = end, fill = party), 
                              ymin = -Inf, ymax = Inf, data = presidential) +
  geom_line(aes(date, unemploy), data = economics)













SkillCraft %>%
  group_by(LeagueIndex) %>%
  summarize(
            mean_HoursPerWeek = mean(HoursPerWeek, na.rm = TRUE),
            mean_APM = mean(APM, na.rm = TRUE),
            mean_MinimapAttacks = mean(MinimapAttacks, na.rm = TRUE),
            mean_UniqueUnitsMade = mean(UniqueUnitsMade, na.rm = TRUE))




x=ranfores(y~x)
x$infortance


