require 'csv'
require 'pry'

require './lib/game'
require './lib/game_team_stats'
require './lib/team_info'

class StatTracker
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


  def count_of_games_by_season
    games_by_season = Hash.new(0)
      games.each do |game|
       games_by_season[game.season] += 1
      end
      games_by_season
   end

 def average_goals_by_season
  goals_by_season = Hash.new(0)
    games.each do |game|
      goals_by_season[game.season] += game.away_goals.to_i + game.home_goals.to_i
    end
    count_of_games_by_season.each do  |season, game_count|
      goals_by_season[season] = (goals_by_season[season] / game_count.to_f).round(2)
    end
    goals_by_season
  end
end
