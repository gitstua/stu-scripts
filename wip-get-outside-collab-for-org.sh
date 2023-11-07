#!/bin/bash

echo work in progress script - not yet working

echo "------------------------------------------------------------"
echo SCRIPT: $0
echo PURPOSE: get outside collaborators for an organization
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
[ -z "$repo_name" ] && read -p "Enter repo name: " repo_name
###################################################

#get list of repos for org and show verbose headers 
gh api "/orgs/$org_name/repos" --jq '.[] '

# gh api "/repos/$org_name/$repo_name/collaborators" --jq '.[] | {login: .login, permissions: .permissions.admin}'

