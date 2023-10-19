read -p "Enter organization name: " org_name

# Get list of repositories in organization
repos=$(gh repo list $org_name --json name --jq '.[].name')

# Loop through each repository and get commit count per day for last 7 days
for repo in $repos
do
    echo "Commit count per day for $repo:"
    gh api "/repos/$org_name/$repo/stats/commit_activity" --paginate --jq '.[] | select(.total > 0) | {date: (.week + 604800) | strftime("%Y-%m-%d"), count: .total}' | sed "s/^/{\"repo\":\"$repo\",/" | sed "s/}$/}/"
    echo ""
done