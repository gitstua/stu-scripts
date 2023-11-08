#!/bin/bash

# Usage function
usage() {
    echo "Usage: $0 <orgname>"
    echo "Example: $0 github"
    echo "Requires: gh CLI tool, jq"
    exit 1
}

# Check for correct number of arguments
if [ $# -ne 1 ]; then
    usage
fi

orgname=$1

# Define supported languages
supported_languages="c cpp csharp go java kotlin javascript typescript python ruby swift"

echo "Searching for repos in $orgname containing supported languages: $supported_languages"

# Get all repos in org
repos=$(gh api orgs/$orgname/repos --paginate | jq -r '.[].name')

# Initialize counters
total_repos=0
matching_repos=0

# Get all repos in org containing supported languages
for repo in $repos; do
  total_repos=$((total_repos + 1))
  languages=$(gh api repos/$orgname/$repo/languages | jq -r 'keys[]')
  for language in $languages; do
    language=$(echo "$language" | tr '[:upper:]' '[:lower:]')
    if [[ $supported_languages =~ (^|[[:space:]])$language($|[[:space:]]) ]]; then
      echo "$orgname/$repo: $language"
      matching_repos=$((matching_repos + 1))
      break
    fi
  done
done

echo "Total repos: $total_repos"
echo "Matching repos: $matching_repos"