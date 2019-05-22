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

  def test_instances_of_games_class
    @stat_tracker.games.each do |game|
      assert_instance_of Game, game
    end
  end

  def test_instances_of_teams_class
    @stat_tracker.teams.each do |team|
      assert_instance_of TeamInfo, team
    end
  end

  def test_instances_of_game_team_stats_class
    @stat_tracker.game_team_stats.each do |game_team|
      assert_instance_of GameTeamStats, game_team
    end
  end

  def test_highest_total_score
    assert_equal 15, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_biggest_blowout
    assert_equal 10, @stat_tracker.biggest_blowout
  end
end
