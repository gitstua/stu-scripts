#! /bin/zsh




# list all the repos in an organization containing languages supported by codeql [ 'c-cpp', 'csharp', 'go', 'java-kotlin', 'javascript-typescript', 'python', 'ruby', 'swift' ] using the gh CLI tool
# Usage: repolist.sh <orgname>
# Example: repolist.sh github
# Requires: gh CLI tool, jq, curl, grep, sed, awk, tr, sort, uniq

# Usage function
usage() {
    echo "Usage: $0 <orgname>"
    echo "Example: $0 github"
    echo "Requires: gh CLI tool, jq, curl, grep, sed, awk, tr, sort, uniq"
    exit 1
}

# Check for correct number of arguments
if ARGV.length != 1
  usage
end

# Check for required commands
for cmd in gh jq curl grep sed awk tr sort uniq; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd could not be found"
        exit 1
    fi
done

# Check for valid org name
orgname=$1
if ! gh api orgs/$orgname &> /dev/null; then
    echo "Organization $orgname not found"
    exit 1
fi

# Get all repos in org
# convert repos to a bash array for processing, replacing newlines with spaces
# Read the repositories into an array
# Initialize an empty array
repos=()

# Read the repositories into the array
while IFS= read -r repo; do
  repos+=("$repo")
done < <(gh api orgs/$orgname/repos | jq -r '.[].name')



# Function to url encode a string
urlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9]) o="${c}" ;;
            *) printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"
}


# Get all repos in org containing supported languages
for repo in ${repos[@]}; do
  languages=()
  while IFS= read -r language; do
    languages+=("$language")
  done < <(gh api repos/$orgname/$repo/languages | jq -r 'keys[]')
  # languages=$(gh api repos/$orgname/$repo/languages | jq -r 'keys[]')
  # echo languages: $languages
  for language in $languages; do
      language=$(echo "$language" | tr '[:upper:]' '[:lower:]')
      case $language in
      c)
          echo "$orgname/$repo: c"
          ;;
      cpp,c++)
          echo "$orgname/$repo: c++"
          ;;
      c#,csharp)
          echo "$orgname/$repo: c#"
          ;;
      go)
          echo "$orgname/$repo: go"
          ;;
      java)
          echo "$orgname/$repo: java"
          ;;
      kotlin)
          echo "$orgname/$repo: kotlin"
          ;;
      javascript)
          echo "$orgname/$repo: javascript"
          ;;
      typescript)
          echo "$orgname/$repo: typescript"
          ;;
      python)
          echo "$orgname/$repo: python"
          ;;
      ruby)
          echo "$orgname/$repo: ruby"
          ;;
      swift)
          echo "$orgname/$repo: swift"
          ;;
      esac
  done
done | sort | uniq