class Repo < TablelessModel
  attr_reader :stars_count, :forks_count, :contributors_count, :id, :name

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @stars_count = attributes[:stars_count]
    @forks_count = attributes[:forks_count]
    @contributors_count = attributes[:contributors_count]
  end
end
