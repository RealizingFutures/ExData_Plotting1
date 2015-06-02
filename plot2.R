## This script downloads the Electric power consumption data, imports the data into R,
## filters the data, creates a linear plot with Global Active Power in the y axis and
## Time in the x axis, and saves the plot to a PNG file called "plot2.png"


## Check to see if director already exists and if not then create directory
## Download zip file which contains the raw data
if(!file.exists("./exploreplots")){dir.create("./exploreplots")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("./exploreplots/plot1.zip")){
        download.file(fileUrl, destfile="./exploreplots/plot1.zip")
}

## Read first 100 lines of data in order to create a vector of the column classes
## then remove the temp data from memory
power.init <- read.table(unz("./exploreplots/plot1.zip", 
        "household_power_consumption.txt"), header = TRUE, sep=";", 
        na.strings = c(NA, "?"), quote = "", nrows = 100)
classes <- sapply(power.init, class)
rm(power.init)

## Read the Electric power consumption data into R
power.raw <- read.table(unz("./exploreplots/plot1.zip", 
        "household_power_consumption.txt"), header = TRUE, sep=";", 
        na.strings = c(NA, "?"), quote = "", nrows = 2100000, colClasses = classes)

## Convert Date and Time columns to date and time classes
power.raw$Date <- as.Date(strptime(power.raw$Date, 
        format = "%d/%m/%Y", tz = "GMT"))
power.raw$Time <- strptime(paste(power.raw$Date, "", power.raw$Time), 
        format = "%Y-%m-%d %H:%M:%S", tz = "GMT")

## Subet the raw power data into 2 days
power <- power.raw[power.raw$Date == as.Date("2007-02-01") | 
        power.raw$Date == as.Date("2007-02-02"),] 


## Creates a linear plot with Global Active Power in the y axis and
## Time in the x axis and saves a PNG file
png(filename = "./exploreplots/plot2.png")
plot(power$Time, power$Global_active_power, type = "l", xlab = "", 
     ylab = "Global Active Power (kilowatts)")
dev.off()

