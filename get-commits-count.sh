#!/bin/bash

echo you need to install GitHub CLI and jq
echo use gh auth login to login to your GitHub account

# add blank line to echo
echo

# Prompt the user to enter the name of the GitHub organization
read -p "Enter the name of the GitHub organization: " org_name

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