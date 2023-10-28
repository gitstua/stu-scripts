#!/bin/bash

echo "------------------------------------------------------------"
echo SCRIPT: $0
echo PURPOSE: Retrieves the runner groups defined for an organization
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
###################################################

gh api "/orgs/$org_name/actions/runner-groups" | jq '.'

# get runner groups and runners for each group and output these to console
runner_groups=$(gh api "/orgs/$org_name/actions/runner-groups" | jq -c '.runner_groups[]')

# Use jq to extract the runner groups
#runner_groups=$(echo "$json_data" | jq -c '.runner_groups[]')

# Loop over the runner groups
for runner_group in $runner_groups
do
  # Extract the name and runners_url
  name=$(echo "$runner_group" | jq -r '.name')
  runners_url=$(echo "$runner_group" | jq -r '.runners_url')

  # Output the name and runners_url
  echo "Name: $name"
  echo "Runners URL: $runners_url"
  
  # Call the runners_url
  runners=$(gh api "$runners_url" | jq '.')
  echo "Runners: $runners"
done