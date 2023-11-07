#!/bin/bash

echo "------------------------------------------------------------"
echo SCRIPT: $0
echo PURPOSE: get copilot related audit events over last week 
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
###################################################

# Get all audit data for the last week
#data=$(gh api "/orgs/$org_name/audit-log" --jq '.[] | select(.created_at > (now - 604800) and (.action | type) == "string" and .action | contains("copilot"))')


gh api "/orgs/$org_name/audit-log" --jq '.[]' > audit.json
# | select(.created_at > (now - 604800))')

# get all elements from audit.json that have a copilot action
#jq '.[] | select(.action | contains("copilot"))' audit.json 

cat audit.json | jq 'select(.action | contains("copilot"))'