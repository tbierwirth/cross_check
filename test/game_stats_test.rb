require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require './lib/game'
require './lib/stat_tracker'
require'./modules/game_stats'

require 'pry'

class GameStatsTest < MiniTest::Test

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

  def test_percentage_home_wins
    assert_equal 49.64, @stat_tracker.home_wins
  end

end
