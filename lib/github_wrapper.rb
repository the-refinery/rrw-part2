require 'github_api'
include Github

class GithubWrapper

  attr_accessor :owner,
                :repo

  def initialize owner, repo
    @owner = owner
    @repo = repo
  end

  def last_commit_age
    commits_api = Github::Repos::Commits.new

    commits = commits_api.list user: ORG, repo: REPO
    sha = commits.first.sha

    commit = commits_api.get user: ORG, repo: REPO, sha: sha

    timestamp = DateTime.parse(commit.commit.committer.date)

    ((DateTime.now - timestamp) * 24 * 60).to_i
  end

end
