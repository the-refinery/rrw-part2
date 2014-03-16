require_relative '../config/github_config'
require 'github_api'
include Github

class GithubWrapper

  attr_accessor :owner,
                :repo

  def initialize owner, repo
    @owner = owner
    @repo = repo

    if GITHUB_TOKEN.empty?
      @api = Github::Repos::Commits.new
    else
      @api = Github::Repos::Commits.new oauth_token: GITHUB_TOKEN
    end
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
