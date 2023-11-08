#!/bin/bash

echo "------------------------------------------------------------"
echo SCRIPT: $0
echo PURPOSE: Retrieves the most common languages for each repository in a given organization
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
###################################################

# Use the GitHub API to retrieve a list of repositories for the organization
repos=$(gh api "/orgs/$org_name/repos" | jq -r '.[].name')



# loop through the repos and get the languages data
for repo in $repos
do
  # get the repo size
  repo_size=$(gh api repos/$org_name/$repo | jq -r '.size')

  # Get the languages data from the GitHub API using gh cli
  response=$(echo $(gh api repos/$org_name/$repo/languages) | jq -c -r '.')

  # prepend the reponame to the response as the first element of the json
  response=$(echo $response | jq --arg reponame $repo '. + {reponame: $reponame}')
  
  # append the repo size to the response as the first element of the json
  response=$(echo $response | jq --arg size $repo_size '. + {totalsize: $size}')

  echo $response
  # echo "------------------------------------------------------------"
done