class FetchRepos
  include Interactor

  before do
    @organization_name = context.organization_name
    @hydra = Typhoeus::Hydra.hydra
  end

  def call
    repos = fetch_repos
    context.repos = repos.map { |args| Repo.new(args) }
  end

  private

  def fetch_repos
    repos = []

    repos_request = Typhoeus::Request.new(
      "https://api.github.com/orgs/#{@organization_name}/repos",
      { method: :get, headers: { Authorization: "token #{ENV["GITHUB_ACCESS_TOKEN"]}" } })

    repos_request.on_complete do |repos_response|
      raw_repos = JSON.parse(repos_response.body)

      raw_repos.each do |raw_repo|
        repo_name = raw_repo["name"]
        contributors_request = fetch_contributors_req(repo_name)
        contributors_request.on_complete do |contributors_response|
          raw_contributors = JSON.parse(contributors_response.body)
          repos << { id:                 raw_repo["id"],
                     name:               repo_name,
                     stars_count:        raw_repo["stargazers_count"],
                     forks_count:        raw_repo["forks_count"],
                     contributors_count: raw_contributors.length }
        end

        @hydra.queue(contributors_request)
      end
    end

    @hydra.queue(repos_request)
    @hydra.run

    repos
  end

  def fetch_contributors_req(repo_name)
    Typhoeus::Request.new(
      "https://api.github.com/repos/#{@organization_name}/#{repo_name}/stats/contributors",
      { method: :get, headers: { Authorization: "token #{ENV["GITHUB_ACCESS_TOKEN"]}" } })
  end
end
