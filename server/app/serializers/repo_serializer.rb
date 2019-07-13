class RepoSerializer
  include FastJsonapi::ObjectSerializer

  set_id :id
  attributes :stars_count, :forks_count, :contributors_count, :name
end
