require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'
require './lib/stat_tracker'
require './lib/modules/game_stats'
require 'pry'

class GameTest < MiniTest::Test

  def setup
    game_path = './data/game.csv'
    team_path = './data/team_info.csv'
    game_teams_path = './data/game_teams_stats.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)

  end

  def test_it_exists
    @stat_tracker.games.each do |game|
      assert_instance_of Game, game
    end
  end

  def test_highest_total_score
    assert_equal 15, @stat_tracker.highest_total_score
  end
end
