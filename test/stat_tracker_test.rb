require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require './lib/game'
require './lib/game_team_stats'
require './lib/team_info'
require './lib/stat_tracker'

require 'pry'

class StatTrackerTest < MiniTest::Test

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

  def test_stat_tracker_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_add_teams_and_count
    assert_equal 33, @stat_tracker.teams.count
    assert_equal 7441, @stat_tracker.games.count
    assert_equal 14882, @stat_tracker.game_team_stats.count
  end

end
