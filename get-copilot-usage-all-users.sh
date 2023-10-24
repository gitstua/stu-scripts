#!/bin/bash

echo UNTESTED SCRIPT - USE AT OWN RISK!
echo you need to install GitHub CLI and jq
echo use gh auth login to login to your GitHub account
echo you may need to also run gh auth refresh -h github.com -s copilot
echo and gh auth refresh -h github.com -s manage_billing:copilot

# add blank line to echo
echo
read -p "Press enter to continue"

# Set the ORG variable to the name of your organization
ORG="yourorganizationname-here"

# Loop through all members of the organization
for username in $(gh api "/orgs/$ORG/members" --jq '.[].login'); do
    # Get the copilot usage for the current user
    copilot_usage=$(gh api "/orgs/$ORG/members/$username/copilot" --jq '.usage')

    # Print the copilot usage for the current user
    echo "$username: $copilot_usage"
done