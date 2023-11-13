#!/bin/bash

echo "------------------------------------------------------------"
echo SCRIPT: $0
echo PURPOSE: get outside collaborators for an organization
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

echo It is recommended you create a PAT token to run this script

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
[ -z "$repo_name" ] && read -p "Enter repo name: " repo_name
###################################################

[ -z "$repo_name" ] && read -p "Enter repo name: " repo_name

filename="output/outside-collaborators.html"

query="
{
  repository(owner:\"$org_name\", name:\"$repo_name\") {
    collaborators(first: 100, affiliation: OUTSIDE) {
      edges {
        node {
          login
          avatarUrl
          url
        }
      }
    }
  }
}
"




gh api graphql -f query="$query" |  jq -r '.data.repository.collaborators.edges[].node | "<a href=\"" + .url + "\">" + .login + "</a><br/><img src=\"" + .avatarUrl + "\" width=\"50px\" height=\"50px\"/><br/>"' > $filename

echo written to $filename