require 'csv'
require 'pry'

require './lib/game'
require './lib/game_team_stats'
require './lib/team_info'
require './lib/modules/game_stats'
require './lib/modules/league_stats'

class StatTracker
  include GameStats
  include LeagueStats 
  attr_reader :games, :teams, :game_team_stats

  def initialize(locations)
    @games = []
    @teams = []
    @game_team_stats = []
    get_game_info(locations[:games])
    get_team_info(locations[:teams])
    get_game_teams_stats(locations[:game_teams])
  end

  def self.from_csv(locations)
    self.new(locations)
  end

  def get_game_info(path)
    CSV.foreach(path, headers: true) do |row|
      @games << Game.new(row)
    end
  end

  def get_team_info(path)
    CSV.foreach(path, headers: true) do |row|
      @teams << TeamInfo.new(row)
    end
  end

  def get_game_teams_stats(path)
    CSV.foreach(path, headers: true) do |row|
      @game_team_stats << GameTeamStats.new(row)
    end
  end
end
