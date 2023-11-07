echo DISCLAIMER: NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
echo "------------------------------------------------------------"

# load .env file if this exists
[ -f .env ] && { set -o allexport; source .env; set +o allexport; } || echo "No .env file not found"

# if not set then prompt for required environment variables
[ -z "$enterprise_name" ] && read -p "Enter enterprise name: " enterprise_name
###################################################

echo $enterprise_name

enterprise_name="stucorp"

query="{
  enterprise (slug: \"stucorp\")
  {
    slug
    databaseId
  }
}

"
# call this using gh cli
 gh api graphql -f query="$query"

# curl -H "Authorization: BEARER_TOKEN" -X POST \
#   -d '{ "query": "query($slug: String!) { enterprise (slug: $slug) { slug databaseId } }" ,
#         "variables": {
#           "slug": "stucorp"
#         }
#       }' \
# https://api.github.com/graphql

# # run a gh cli command to get the database name
#  gh api graphql -f query='query($slug: String!) { enterprise(slug: $slug) { slug databaseId } }' -F variables="{\"slug\": \"stucorp"}