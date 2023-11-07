#!/bin/bash

echo "------------------------------------------------------------"
echo SCRIPT: $0
echo PURPOSE: Retrieves the count of commits for each repository in a given organization
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
[ -z "$repo_name" ] && read -p "Enter repo name: " repo_name

###################################################

full_repo_path="/repos/$org_name/$repo_name"

echo "searching for contributors in $full_repo_path ..."

gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/$org_name/$repo_name/contributors

  # call the same api and just display userid and count
  gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/$org_name/$repo_name/contributors \
 | jq -r '.[] | "\(.login) \(.contributions)"' 