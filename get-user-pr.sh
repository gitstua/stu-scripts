#!/bin/bash

echo you need to install GitHub CLI and jq
echo use gh auth login to login to your GitHub account


# Prompt the user to enter the name of the GitHub organization and default to dadstaxi
read -p "Enter the name of the GitHub organization: (default:dadstaxi)" org_name
org_name=${org_name:-dadstaxi}

read -p "Enter the SSO email of the user: " user_email

# use graphql to get the user id from the sso identity using externalIdentities and samlIdentityProvider
user_id=$(gh api graphql -f query="query { organization(login: \"$org_name\") { samlIdentityProvider { externalIdentities(userName: \"$user_email\", first: 1) { nodes { user { login } } } } } }" --jq '.data.organization.samlIdentityProvider.externalIdentities.nodes[0].user.login')

# use graphql to get the all the pr with pr url and name created by the user_id as a list in org_name
pr=$(gh api graphql -f query="query { search(query: \"org:$org_name is:pr author:$user_id\", type: ISSUE, first: 100) { nodes { ... on PullRequest { url title } } } }" --jq '.data.search.nodes')

#loop through and write out the pr url and name
for pr_url in $(echo $pr | jq -r '.[].url'); do
    pr_name=$(echo $pr | jq -r --arg pr_url "$pr_url" '.[] | select(.url == $pr_url) | .title')
    echo "$pr_name: $pr_url"
done
