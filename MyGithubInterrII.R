#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)
install.packages("plotly")
library(plotly)
install.packages("devtools")
library(devtools)
install.packages("magrittr")
library(magrittr)
install.packages("dplyr")
library(dplyr)
detach(package:plotly, unload=TRUE)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = "MyGithubInterrogationII",
                   key = "1e44ff15655145df1371",
                   secret = "a8609711bb0dbafb5b4d9789cd68e0ff47426988")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/corcorl1/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

#Connecting to my Plotly account 
Sys.setenv("plotly_username"="corcorl1")
Sys.setenv("plotly_api_key"="K7LVLU895AM0p8DNYPBy")

getFollowers <- function(corcorl1)
{
  URL <- paste("https://api.github.com/users/", corcorl1 , "/followers", sep="")
  followers = fromJSON(URL)
  return (followers$login)
}

getFollowing <- function(corcorl1)
{
  URL <- paste("https://api.github.com/users/", corcorl1 , "/following", sep="")
  followers = fromJSON(URL)
  return (followers$login)
}

#Function that returns a list of the provided user's repositories
getRepositories <- function(corcorl1)
{
  URL <- paste("https://api.github.com/users/", corcorl1 , "/repos", sep="")
  repos = fromJSON(URL) 
  repos$committs
  return (repos$name)
}

