require_relative 'lib/github_wrapper'

ORG = "d-i"
REPO = "rrw-demo"

github = GithubWrapper.new ORG, REPO

puts github.latest_commit_age

