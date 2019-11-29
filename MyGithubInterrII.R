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

for(i in 1:length(user_ids))
{
  
  followingURL = paste("https://api.github.com/users/", user_ids[i], "/following", sep = "")
  followingRequest = GET(followingURL, gtoken)
  followingContent = content(followingRequest)
  
  #Does not add users if they have no followers
  if(length(followingContent) == 0)
  {
    next
  }
  
  followingDF = jsonlite::fromJSON(jsonlite::toJSON(followingContent))
  followingLogin = followingDF$login
  
  #Loop through 'following' users
  for (j in 1:length(followingLogin))
  {
    #Check for duplicate users
    if (is.element(followingLogin[j], users) == FALSE)
    {
      #Adds user to the current list
      users[length(users) + 1] = followingLogin[j]
      
      #Obtain information from each user
      followingUrl2 = paste("https://api.github.com/users/", followingLogin[j], sep = "")
      following2 = GET(followingUrl2, gtoken)
      followingContent2 = content(following2)
      followingDF2 = jsonlite::fromJSON(jsonlite::toJSON(followingContent2))
      
      #Retrieves who user is following
      followingNumber = followingDF2$following
      
      #Retrieves users followers
      followersNumber = followingDF2$followers
      
      #Retrieves how many repository the user has 
      reposNumber = followingDF2$public_repos
      
      #Retrieve year which each user joined Github
      yearCreated = substr(followingDF2$created_at, start = 1, stop = 4)
      
      #Add users data to a new row in dataframe
      usersDB[nrow(usersDB) + 1, ] = c(followingLogin[j], followingNumber, followersNumber, reposNumber, yearCreated)
      
    }
    next
  }
  #Stop when there are more than 10 users
  if(length(users) > 150)
  {
    break
  }
  next
}

Sys.setenv("plotly_username"="corcorl1")
Sys.setenv("plotly_api_key"="K7LVLU895AM0p8DNYPBy")

plot1 = plot_ly(data = usersDB, x = ~repos, y = ~followers, text = ~paste("Followers: ", followers, "<br>Repositories: ", repos, "<br>Date Created:", dateCreated), color = ~dateCreated)
plot1

plot2 = plot_ly(data = usersDB, x = ~following, y = ~followers, text = ~paste("Followers: ", followers, "<br>Following: ", following), color = ~dateCreated)
plot2

api_create(plot1, filename = "Repositories vs Followers")
api_create(plot2, filename = "Following vs Followers")

#below code is to graph the top 10 most popular languages used by the same 250 users.
languages = c()

