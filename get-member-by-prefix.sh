#!/bin/bash

echo "------------------------------------------------------------"
echo SCRIPT: $0
echo PURPOSE: For an org, get the member logins which begin with a prefix
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
[ -z "$prefix" ] && read -p "Enter prefix user login: " prefix
###################################################

# use graphql to print members of the organization and filter login by prefix
#gh api graphql -f query="query { organization(login: \"$org_name\") { membersWithRole(first: 100) { nodes { login } } } }" --jq '.data.organization.membersWithRole.nodes[] | select(.login | startswith("'$prefix'"))'

members=$(gh api graphql -f query="query { organization(login: \"$org_name\") { membersWithRole(first: 100) { nodes { login } } } }" --jq '.data.organization.membersWithRole.nodes[] | select(.login | startswith("'$prefix'"))')

# print out the members
echo $members 

echo 