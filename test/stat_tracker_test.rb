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
    @stat_tracker = StatTracker.new
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_add_teams_and_count
    assert_equal 33, StatTracker.from_csv
  end

end
