# 
# What: Code province for IBC events data
# Date: March 2012
# By:   Andreas Beger
#
# Creative Commons BY-NC-SA 3.0 License:
# Attribution, Non-Commercial, Share Alike
#

setwd("/Users/adbeger/Research/Code_IBC_Province")

#
# Load libraries
#

library(stringr)

#
# Functions
#

# GetProvince ; translates a colloquial location description into province
GetProvince <- function(location, city.prov) {
  # Function for deleting "al-" and other special characters
  DelChar <- function(x) {
    word <- sub("al-", "", x, ignore.case = TRUE)
    word <- gsub("'[s]", "", word)
    word <- gsub("[?,']", "", word)
    return(word)
  }
  
  # Function for looking up in city-province list
  ProvLook <- function(x) {
    province <- NULL
    repeat {
      if (x %in% city.prov[, 2]) {
        province <- x
        break
      } else if (x %in% city.prov[, 1]) {
        province <- city.prov[(x==city.prov[, 1]), 2]
        break
      } else {
        province <- "no match"
        break
      }
    }
    return(province)
  }
  
  # Split up into separate words and get number of words
  words <- str_trim(location)
  words <- unlist(strsplit(words, " "))
  words <- unlist(strsplit(words, "/"))
  n <- length(words)
  
  province <- ""
  while (province == "") {
    # Exception for zero length location
    if (location == "") { 
      province <- "no location"
      break
    }
    
    # Loop to get candidate string
    for (i in n:1) {
      # Get a candidate value for province
      p.cand <- DelChar(words[i])
      # Look up candidate value
      province <- ProvLook(p.cand)
      if (province != "no match") { break }
    }
    
    # Note if no matches
    if (province == "no match") {
      province <- paste("Z:", location)
    }
  }
  return(province)
}

dead.event <- read.table("data/ibc-incidents-2012-3-6.csv", 
                         header = TRUE, skip = 10, sep = ",",
                         stringsAsFactor = FALSE)
dead.event$Location[dead.event$IBC.code=="x485"] <- "Baghdad"

# List of city province tuples
city.prov <- read.table("data/citylist.csv", header = FALSE, skip = 1, sep = ",",
                        stringsAsFactor = FALSE)
city.prov <- as.matrix(city.prov)
dimnames(city.prov) <- NULL

# Actual coding, this will take several seconds to run
location <- dead.event$Location
province <- unlist(lapply(location, function(x) {GetProvince(x, city.prov)}))

# Drop columns not needed
dead.event$Province <- province
keep <- c("IBC.code", "Start.Date", "End.Date", "Reported.Minimum", "Reported.Maximum", 
          "Province")
dead.event <- dead.event[keep]

# Replace "no location" and "Z: ..." with NA
dead.event$Province[substr(province, 1, 2)=="Z:"] <- NA
dead.event$Province[province=="no location"] <- NA

# Export to csv
write.csv(dead.event, file = "data/IBC_event.csv", row.names = FALSE)

