# write a script that is interactive and asks the user for which script they want to run
# there will be 3 scripts, one for each of the following:
# 1. global committer count
# 2. configurable committer count
# 3. committer count for repos with codeQL supported languages
# 4. committer count that excludes repos with 70% markdown files

puts "Please select the script you want to run:"
puts "1. Global committer count"
puts "2. Configurable committer count"
puts "3. Committer count for repos with CodeQL supported languages"
puts "4. Committer count that excludes repos with 70% markdown files"

choice = gets.chomp.to_i

case choice
when 1
    # First script is below - global committer count

    # frozen_string_literal: true
    # ghe-console -y < /path/to/this/script.rb
    # THIS SCRIPT CAN BE USED TO CALCULATE YOUR MAXIMUM ADVANCED SECURITY COMMITTER COUNT
    # IF ADVANCED SECURITY WAS ENABLED FOR EVERY REPOSITORY
    # on GHES 3.0.1 this script is available via:
    #  github-env ghe-advanced-security-global-committer-count
    ActiveRecord::Base.connected_to(role: :reading) do
        puts "Version 1.2.2"
        emails = Set.new
        start_time = 90.days.ago.beginning_of_day
        Repository.where(active: true).find_in_batches do |batch|
        Configurable.try(:preload_configuration, batch)
        batch.each do |repo|
            Push
            .where(repository: repo)
            .where("created_at >= ?", start_time)
            .find_in_batches do |push_batch|
                push_batch.each do |push|
                begin
                    push.commits_pushed.each do |commit|
                    commit.author_emails.each do |email|
                        emails << email unless UserEmail.belongs_to_a_bot?(email)
                    end
                    end
                rescue GitRPC::BadObjectState, GitRPC::BadGitmodules, GitRPC::SymlinkDisallowed, GitRPC::Timeout => e
                    puts "Git error while fetching commit: '#{push.after}'. #{e.class}: #{e.message}"
                end
                end
            end
        end
        end
        users = Set.new
        emails.each_slice(1000) do |batch|
        emails_to_users_hash = User.find_by_emails(batch)
        active_users = emails_to_users_hash.values.select do |user|
            !(user.disabled? || user.suspended?)
        end
        users.merge(active_users)
        end
        puts "All committers in the past 90d: #{users.size}"
    end

when 2
# Second script is below - configurable committer count

# frozen_string_literal: true
# 1) start github-console:
#   ~$ ghe-console -y
# 2) paste script in directly or load script from file with:
#   GitHub[production] (main):001:0> load "/path/to/this/script.rb"
# THIS SCRIPT WILL COUNT THE COMMITTERS OF REPOSITORIES WHERE ADVANCED SECURITY IS ENABLED
# PLUS ANY ADDITIONAL ORGANIZATIONS OR REPOSITORIES THAT DO NOT CURRENTLY HAVE GHAS, SPECIFIED IN THE FORMAT (one per line):
# ORGANIZATION
# ORGANIZATION/REPOSITORY
# on GHES 3.0.1 this script is available via:
#  github-env ghe-advanced-security-configurable-committer-count
ActiveRecord::Base.connected_to(role: :reading) do
    puts """Enter or paste a list of organizations and/or repositories, one per line, e.g:
    OrganizationName
    OrganizationName/RepositoryName
  
  Press Control+D when finished:
    """
    repos, orgs = STDIN.readlines.map(&:strip).filter.partition { |line| line.include?("/") }.map(&:to_set)
    org_ids = Set.new
    orgs.each_slice(1000) { |batch| org_ids.merge(User.where(type: "organization", login: batch).pluck(:id)) }
    puts "Version 1.2.2"
    start_time = 30.days.ago.beginning_of_day
    sql = ApplicationRecord::Base.github_sql.run(<<-SQL, {start_time: start_time})
      SELECT DISTINCT repository_id FROM ts_analyses WHERE created_at >= :start_time
    SQL
    code_scanning_repos = Set.new(sql.results.flatten)
    emails = Set.new
    start_time = 90.days.ago.beginning_of_day
    scope = Repository.where(active: true).find_in_batches do |batch|
      Configurable.try(:preload_configuration, batch)
      batch.each do |repo|
        next unless code_scanning_repos.member?(repo.id) || repo.token_scanning_enabled? || org_ids.include?(repo.owner_id) || repos.include?(repo.nwo)
        Push
          .where(repository: repo)
          .where("created_at >= ?", start_time)
          .find_in_batches do |push_batch|
            push_batch.each do |push|
              begin
                push.commits_pushed.each do |commit|
                  commit.author_emails.each do |email|
                    emails << email unless UserEmail.belongs_to_a_bot?(email)
                  end
                end
              rescue GitRPC::BadObjectState, GitRPC::BadGitmodules, GitRPC::SymlinkDisallowed, GitRPC::Timeout => e
                puts "Git error while fetching commit: '#{push.after}'. #{e.class}: #{e.message}"
              end
            end
          end
      end
    end
    users = Set.new
    emails.each_slice(1000) do |batch|
      emails_to_users_hash = User.find_by_emails(batch)
      active_users = emails_to_users_hash.values.select do |user|
        !(user.disabled? || user.suspended?)
      end
      users.merge(active_users)
    end
    puts "Advanced Security committers + additional organizations/repositories in the past 90d: #{users.size}"
  end


when 3
# Third script is below - committer count for repos with codeQL supported languages

# write a script that hits the GitHub Server API and scans all organisations in the Enterprise to return only the repositories with supported CodeQL languages, which are
# C and C++ , C#, Go, Java and Kotlin, JavaScript and TypeScript, Python, Ruby, Swift (list taken from: https://codeql.github.com/docs/codeql-language-guides/)
# The script should return the following information for each repository:
# OrganisationName/repositoryName
# this list should be saved to a file and the number of repositories should be counted and printed to the console





when 4
# Fourth script is below - committer count that excludes repos with 70% markdown files





# error handling for invalid choice
else
    puts "Invalid choice. Please select a number between 1 and 4."
  end  







