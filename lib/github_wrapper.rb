require 'github_api'
include Github

class GithubWrapper

  attr_accessor :owner,
                :repo

  def initialize owner, repo
    @owner = owner
    @repo = repo

    @api = Github::Repos::Commits.new
  end

  def latest_commit_sha
    commits = @api.list user: ORG, repo: REPO
    commits.first.sha
  end

  def latest_commit_detail
    sha = latest_commit_sha
    @api.get user: ORG, repo: REPO, sha: sha
  end

  def latest_commit_age
    commit = latest_commit_detail

    timestamp = DateTime.parse(commit.commit.committer.date)

    ((DateTime.now - timestamp) * 24 * 60).to_i
  end

end
