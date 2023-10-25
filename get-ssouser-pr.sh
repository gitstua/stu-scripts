#!/bin/bash

echo "------------------------------------------------------------"
echo PURPOSE: For an org with SSO enabled, get the list of PRs created by a user by sso email
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
[ -z "$user_email" ] && read -p "Enter SSO user email: " user_email
###################################################

# use graphql to get the user id from the sso identity using externalIdentities and samlIdentityProvider
user_id=$(gh api graphql -f query="query { organization(login: \"$org_name\") { samlIdentityProvider { externalIdentities(userName: \"$user_email\", first: 1) { nodes { user { login } } } } } }" --jq '.data.organization.samlIdentityProvider.externalIdentities.nodes[0].user.login')

# use graphql to get the all the pr with pr url and name created by the user_id as a list in org_name
pr=$(gh api graphql -f query="query { search(query: \"org:$org_name is:pr author:$user_id\", type: ISSUE, first: 100) { nodes { ... on PullRequest { url title } } } }" --jq '.data.search.nodes')

#loop through and write out the pr url and name and user_id
for pr_url in $(echo $pr | jq -r '.[].url'); do
    pr_name=$(echo $pr | jq -r --arg pr_url "$pr_url" '.[] | select(.url == $pr_url) | .title')
    echo "$user_id, $pr_url , $pr_name"
done

echo 