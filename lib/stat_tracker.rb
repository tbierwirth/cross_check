require 'csv'
require 'pry'

require './lib/game'
require './lib/game_team_stats'
require './lib/team_info'

class StatTracker
  attr_reader :games

  @games = []
  @teams = []
  @team_info_path = './data/team_info.csv'

  def self.from_csv
    CSV.foreach(@team_info_path, headers: true) do |row|
      @teams << TeamInfo.new(row)
    end
    @teams.count
    # binding.pry
  end

end
