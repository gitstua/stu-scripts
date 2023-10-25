#!/bin/bash

echo "------------------------------------------------------------"
echo PURPOSE: Retrieves the count of commits for each repository in a given organization
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

for repo in $repos
do
    # Use the GitHub API to retrieve a list of commits for the current repository
    commits=$(gh api "/repos/$org_name/$repo/commits" | jq -r '.[].sha')

    # Get the count of commits for the current repository
    repo_commits=$(echo $commits | wc -w)

    # Output the count of commits for the current repository
    echo "Commits for $org_name/$repo: $repo_commits"
done

echo 