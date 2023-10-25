#!/bin/bash

echo "------------------------------------------------------------"
echo SCRIPT: $0
echo PURPOSE: Retrieves the usage of GitHub Copilot for all members of a given organization
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo you may need to run `gh auth refresh -h github.com -s copilot` before running this script
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
###################################################

# Loop through all members of the organization
for username in $(gh api "/orgs/$org_name/members" --jq '.[].login'); do
    # Get the copilot usage for the current user
    copilot_usage=$(gh api "/orgs/$org_name/members/$username/copilot" --jq '.usage')

    # Print the copilot usage for the current user
    echo "$username: $copilot_usage"
done

echo 
