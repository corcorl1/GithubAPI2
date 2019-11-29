install.packages("jsonlite")
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
#detach(package:plotly, unload=TRUE)

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
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 


#Interrogate the Github API to extract data from my own github account

#Connecting to my Plotly account 
Sys.setenv("plotly_username"="corcorl1")
Sys.setenv("plotly_api_key"="K7LVLU895AM0p8DNYPBy")

ownData = fromJSON("https://api.github.com/users/corcorl1")

ownData$followers

ownFollowers = fromJSON("https://api.github.com/users/corcorl1/followers")

followers$login

ownData$following

following = fromJSON("https://api.github.com/users/corcorl1/following")

following$login

ownData$public_repos

repos = fromJSON("https://api.github.com/users/corcorl1/repos")
repos$name
repos$created_at
repos$full_name

ownData$bio

berryd1Data = fromJSON("https://api.github.com/users/berryd1")
berryd1Data$followers
berryd1Data$following
berryd1Data$public_repos

#decided to use the account of Corentin Jermine was in November 2019 Githubs most active member,
#felt information from his account would produce much more interesting graphs than my own information 
#user => fabpot 

ownData = GET("https://api.github.com/users/CorentinJ/followers?per_page=100;", gtoken)
stop_for_status(ownData)
extract = content(ownData)
#converts into dataframe
githubDB = jsonlite::fromJSON(jsonlite::toJSON(extract))
githubDB$login

id = githubDB$login
user_ids = c(id)

users = c()
usersDB = data.frame(
  username = integer(),
  following = integer(),
  followers = integer(),
  repos = integer(),
  dateCreated = integer()
)

