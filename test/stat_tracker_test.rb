require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require './lib/game'
require './lib/game_team_stats'
require './lib/team_info'
require './lib/stat_tracker'
require './lib/modules/game_stats'
require './lib/modules/league_stats'

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

  def test_count_of_games_by_season
    expected = {"20122013" => 806,"20162017"=>1317, "20142015"=>1319, "20152016"=>1321, "20132014"=>1323, "20172018"=>1355}
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_average_number_of_goals_in_a_game_by_season
    expected = {"20122013" => 5.40,"20162017"=> 5.51, "20142015"=> 5.43, "20152016"=> 5.41, "20132014"=> 5.50, "20172018"=> 5.94}
    assert_equal expected, @stat_tracker.average_goals_by_season
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

  def test_percentage_home_wins
    assert_equal 0.55, @stat_tracker.percentage_home_wins
  end

  def test_percentage_away_wins
    assert_equal 0.45, @stat_tracker.percentage_visitor_wins
  end

  def test_average_goals_per_game
    assert_equal 5.54, @stat_tracker.average_goals_per_game
  end

  def test_winningest_team
    assert_equal "Golden Knights", @stat_tracker.winningest_team
  end

  def test_best_fans
    assert_equal "Coyotes", @stat_tracker.best_fans
  end

  def test_worst_fans
    assert_equal [], @stat_tracker.worst_fans
  end

  def test_best_offense_league_stats
    assert_equal "Golden Knights", @stat_tracker.best_offense
  end

  def test_worst_offense_league_stats
    assert_equal "Sabres", @stat_tracker.worst_offense
  end

  def test_best_defense_league_stats
    assert_equal "Kings", @stat_tracker.best_defense
  end

  def test_worst_defense_league_stats
    assert_equal "Coyotes", @stat_tracker.worst_defense
  end

  def test_count_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_can_find_highest_scoring_visitor
    expected = "Capitals"
    assert_equal expected, @stat_tracker.highest_scoring_visitor
  end

  def test_can_find_lowest_scoring_visitor
    expected = "Sabres"
    assert_equal expected, @stat_tracker.lowest_scoring_visitor
  end

  def test_can_find_lowest_scoring_home_team
    expected = "Sabres"
    assert_equal expected, @stat_tracker.lowest_scoring_home_team
  end

  def test_can_find_highest_scoring_home_team
    expected = "Golden Knights"
    assert_equal expected, @stat_tracker.highest_scoring_home_team
  end

  def test_best_season
    assert_equal "20132014", @stat_tracker.best_season("6")
  end

  def test_worst_season
    assert_equal "20142015", @stat_tracker.worst_season("6")
  end

  def test_biggest_team_blowout
    assert_equal 7, @stat_tracker.biggest_team_blowout("18")
  end
end
