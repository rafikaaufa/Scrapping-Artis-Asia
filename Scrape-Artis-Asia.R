message("Loading Packages")
library(tidyverse)
library(rvest)
library(mongolite)

message('Cleaning Data')
url<-"https://mydramalist.com/stats/leaderboards/weekly"
drama<-read_html(url)
ar2<-drama %>% html_nodes(".fs-item") %>% html_text2() %>% str_split("\n")
data<-data.frame(posisi=0,nama=0,asal=0,point=0)
for (i in 1:100){
  data$waktu_scrape<-Sys.time()
  data[i,1]<-as.numeric(sort(ar2[[i]][1]))
  data[i,2]<-ar2[[i]][2]
  data[i,3]<-ar2[[i]][3]
  data[i,4]<-as.numeric(gsub(",",".",ar2[[i]][4]))
}
data2 <- data %>% arrange(posisi)
data2

message('Input Data ke MongoDB Atlas')
atlas_conn <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas_conn$insert(data2[sample(1:nrow(data2),2),])
