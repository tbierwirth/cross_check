require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'
require './lib/stat_tracker'
require './lib/game_stats'
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

  # def test_it_exists
  #   row = {"game_id": "2012030221","season": "20122013","type": "P","date_time": 2013-05-16,"away_team_id": "3","home_team_id": "6","away_goals": 2,"home_goals": 3,"outcome": "home win OT","home_rink_side_start": "left","venue": "TD Garden","venue_link": "/api/v1/venues/null","venue_time_zone_id": "America/New_York","venue_time_zone_offset": -4,"venue_time_zone_tz": "EDT"}
  #   game = Game.new(row)
  #   assert_instance_of Game, game
  # end

  def test_it_exists
    @stat_tracker.games.each do |game|
      assert_instance_of Game, game
    end
  end

  def test_highest_total_score
    assert_equal 15, @stat_tracker.highest_total_score
  end
end
