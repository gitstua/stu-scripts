#!/bin/bash

echo "------------------------------------------------------------"
echo SCRIPT: $0
echo PURPOSE: get weekly commit count for last 52 weeks for all repositories in an organization
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
###################################################

# Get list of repositories in organization
repos=$(gh repo list $org_name --json name --jq '.[].name')

# Loop through each repository and output weekly commit count for last 52 weeks if there are any commits in that week
for repo in $repos
do
    echo "Commit count per day for $repo:"
    gh api "/repos/$org_name/$repo/stats/commit_activity" --paginate --jq '.[] | select(.total > 0) | {date: (.week + 604800) | strftime("%Y-%m-%d"), count: .total}' | sed "s/^/{\"repo\":\"$repo\",/" | sed "s/}$/}/"
    echo ""
done

echo 