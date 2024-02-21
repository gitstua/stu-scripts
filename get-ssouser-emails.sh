#!/bin/bash

echo "------------------------------------------------------------"
echo SCRIPT: $0
echo PURPOSE: For an org with SSO enabled, get the list of sso email
echo PRE-REQUISITES: see https://github.com/gitstua/stu-scripts#pre-requisites
echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$org_name" ] && read -p "Enter organization name: " org_name
###################################################

# user_email=$(gh api graphql -f query="query { organization(login: \"$org_name\") { samlIdentityProvider { externalIdentities(first: 100) { nodes { user { ... } } } } }"  )



# #loop through and write out the user email
# for email in $(echo $user_email | jq -r '.[]'); do
#     echo $email
# done

# https://github.com/github/platform-samples/issues/168#issuecomment-873631750
gh api graphql --paginate -f query="
query(\$endCursor: String) {
  organization(login: \"${org_name}\") {
    samlIdentityProvider {
      ssoUrl,
      externalIdentities(first: 100, after: \$endCursor) {
        edges {
          node {
            guid,
            samlIdentity {
              nameId
            }
            user {
              login
            }
          }
        }
        pageInfo{
          hasNextPage,
          endCursor
        }
      }
    }
  }
}
"

echo 