## run_analysis.R

## get and download the file
if(!dir.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")

## unzip the file into the current directory
unzip("./data/Dataset.zip", exdir = ".")