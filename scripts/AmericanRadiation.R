library(dplyr)
library(stringr)
library(tidyr)
library(cowplot)
options(digits=10)
setwd("../Data")

##read all the downloaded files
myfiles <- list.files(pattern="*.csv")
files <- do.call(rbind, lapply(myfiles, function(x) read.csv(x, stringsAsFactors = FALSE)))
head(files)


#check if files are loaded correctly
table(files$LOCATION_NAME)
length(files$MONITOR.ID)

#split the sample collection time into time, day, month, year
files["month"] <- substr(files$SAMPLE.COLLECTION.TIME, 1, 2)
files["day"] <- substr(files$SAMPLE.COLLECTION.TIME, 4, 5)
files["year"] <- substr(files$SAMPLE.COLLECTION.TIME, 7, 10)
files["time"] <- substr(files$SAMPLE.COLLECTION.TIME, 12, 13)
head(files)

#check if the string split did it correctly
table(files$month)
table(files$day)
table(files$year)
table(files$time)

#create a new column with month and year information
files["month_year"] <- paste(files$year, files$month, sep="/")
head(files)

#check the data
summary(files$GAMMA.COUNT.RATE.R02..CPM.)

names(files)


#remove the rows where radiation values contain NA
files.com <- files[complete.cases(files[, 5:12]), ]


length(files$MONITOR.ID)
length(files.com$MONITOR.ID)

names(files.com)
head(files.com)

table(files.com$LOCATION_NAME)

#change location name for convenient usage in the future
files.com["location"] <- substr(files.com$LOCATION_NAME, 5, 1000000L)
head(files.com)

table(files.com$location)

#look at the example in Denver, as it is the closest city near where I live
Denver <- filter(files.com, location == "DENVER")
head(Denver)
names(Denver)

#shrink the data, delete unnecessary information
Denver.slim <- Denver[, c(5:12,14:18)]
names(Denver.slim)[1:8] <- c("R02", "R03", "R04", "R05", "R06", "R07", "R08", "R09")
head(Denver.slim)

#convert from wide to long format
Denver.long <- gather(Denver.slim, rate, measurement, R02:R09)

head(Denver.long)

#plot out how each level of radiation change across months in the recent >10 years in Denver
ggplot(data=Denver.long, aes(x=month_year, y=measurement)) + geom_point(size=0.5, alpha=0.5) + facet_wrap(~rate, scales="free_y", nrow=2) 

#it showed when the radiation harzard increases, the radition level increase across years more dramatically.
ggsave("Denver.monthAndYearTrend.pdf")

#foucus on R09, to see how radiation level changes across month in each year
Denver07_17_R09 <- filter(Denver.long, year!= "2006" & year!= "2018") %>% filter(rate=="R09")

ggplot(data=Denver07_17_R09, aes(x=month, y=measurement)) + facet_wrap(~year, scales="free_y", ncol=3) + geom_point(alpha=0.5, size=0.5) + geom_smooth(method="loess", stat = 'smooth', linetype = 'solid', formula=y~x, size=6) + theme(axis.text.x=element_text(size = 6)) 

#no obvious pattern found, generally lower radiation in summer but higher in winter (OCT, NOV )
ggsave("DenverR09_month.pdf")

#focus on data from 2018 March in Denver to see how radiation change across time within a day, 
#the highest radiation appears at around 12-13pm
Denver2018March <- filter(Denver.long, year==2018 & month=="03")
ggplot(Denver2018March, aes(x=time, y=measurement)) + geom_smooth(method = "loess", color="blue", formula = y ~ x) + geom_point()+ facet_wrap(~rate, scales="free_y", nrow=4)+theme(axis.text.x=element_text(size = 6)) 
ggsave("Denver2018March_timePattern.pdf")

#shift to the big dataset including multiple states
names(files.com)[5:12] <- c("R02", "R03", "R04", "R05", "R06", "R07", "R08", "R09")
head(files.com)
files.slim <- files.com[, c(5:12, 14:19)]
head(files.slim)


# to investigate how the most harzardous radiation change across years in different state
#and found not all states increases the radiation level across time, some decrease a lot, such as New York city
# further question could be: what policies has NYC taken to reduce the radiation level? what we can learn from it?
ggplot(data=files.slim, aes(x=month_year, y=R09)) + geom_point(size=0.5, alpha=0.5) + facet_wrap(~location, scales="free_y", nrow=4)+theme(strip.text.x = element_text(size = 6, colour = "black")) 
ggsave("representativeStateR09Pattern_month_year.pdf")

#indicate which year the radiation changed dramatically
ggplot(data=files.slim, aes(x=year, y=R09)) + geom_point(size=0.5, alpha=0.5) + facet_wrap(~location, scales="free_y", nrow=4)+theme(strip.text.x = element_text(size = 6, colour = "black"), axis.text.x=element_text(size = 6, , angle = 90, hjust = 1)) + geom_smooth(method="loess", size=6) 
ggsave("representativeStateR09Pattern_year.pdf")

#restrict the data to 2018 April, the most recent month, to compare the radiation difference among some big cities

files2018April <- filter(files.slim, year=="2018" & month=="04")
head(files2018April)
files2018April.long <- gather(files2018April, rate, measurement, R02:R09)

#Denver has the highest radiation, could it be related with the mining industry neaby?
#fairbanks, duluth, honolulu etc showed lower radiation
ggplot(data=files2018April.long, aes(x=location, y=measurement)) + geom_boxplot(aes(color=location)) + facet_wrap(~rate, scales="free_y", nrow=4)+theme(strip.text.x = element_text(size = 10, colour = "black"), axis.text.x=element_text(size = 6, , angle = 90, hjust = 1), legend.position="none") 
ggsave("representativeState2018AprilPattern.pdf")
