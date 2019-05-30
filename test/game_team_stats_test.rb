require 'simplecov'
SimpleCov.start
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game_team_stats'
require 'pry'

class GameTeamStatsTest < MiniTest::Test

  def setup

    @game_team_stats = GameTeamStats.new({"game_id": "2012030221", "team_id": "3", "HoA": "away", "won": false, "settled_in": "OT", "head_coach": "John Tortorella", "goals": 2, "shots": 35, "hits": 44, "pim": 8, "powerPlayOpportunities": 3, "powerPlayGoals": 0, "faceOffWinPercentage": 44.8, "giveaways": 17, "takeaways": 7})
  end

  def test_it_exists

    assert_instance_of GameTeamStats, @game_team_stats
  end

end
