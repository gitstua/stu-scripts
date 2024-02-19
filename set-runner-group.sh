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

[ -z "$runner_group_name" ] && read -p "Enter runner group name: " repo_name

###################################################

# Define the full repository path
full_repo_path="/repos/$org_name/$repo_name"  # replace with your organization and repository name

# list all runner groups
#gh api /orgs/$org_name/actions/runner-groups | jq

# read the runner group id
runner_group_id=$(gh api /orgs/$org_name/actions/runner-groups | jq -r --arg runner_group_name "$runner_group_name" '.runner_groups[] | select(.name == $runner_group_name) | .id')

# get the selected_repositories_url for the runner group
selected_repositories_url=$(gh api /orgs/$org_name/actions/runner-groups/$runner_group_id | jq -r .selected_repositories_url)

echo show the runner group
gh api /orgs/$org_name/actions/runner-groups/$runner_group_id | jq

echo set a repository for the runner group
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /orgs/$org_name/actions/runner-groups/$runner_group_id/repositories \
  -F "selected_repository_ids[]=596893670" 

echo show all selected repositories for the runner group
gh api $selected_repositories_url | jq

echo run again and return the name of each repository
gh api $selected_repositories_url | jq -r '.repositories[] | .name'

echo clear the list of selected repositories for the runner group  
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /orgs/$org_name/actions/runner-groups/$runner_group_id/repositories \
  -F "selected_repository_ids[]" 

  #-F "selected_repository_ids[]=596893670" 

echo run again and return the name of each repository
gh api $selected_repositories_url | jq -r '.repositories[] | .id, .name'

echo show the runner group
gh api /orgs/$org_name/actions/runner-groups/$runner_group_id | jq

echo update the runner group to visibility all
gh api \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /orgs/$org_name/actions/runner-groups/$runner_group_id \
  -F "visibility=all"

echo show the runner group
gh api /orgs/$org_name/actions/runner-groups/$runner_group_id | jq
