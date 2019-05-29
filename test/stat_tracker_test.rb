require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require './lib/game'
require './lib/game_team_stats'
require './lib/team_info'
require './lib/stat_tracker'
require './lib/modules/game_stats'
require './lib/modules/league_stats'
require './lib/modules/team_stats'
require './lib/modules/season_stats'

require 'pry'

class StatTrackerTest < MiniTest::Test

  def setup
    game_path = './test/data/test_game.csv'
    team_path = './test/data/test_team_info.csv'
    game_teams_path = './test/data/test_game_teams_stats.csv'

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
    assert_equal 806, @stat_tracker.games.count
    assert_equal 1615, @stat_tracker.game_team_stats.count
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
    expected = {"20122013" => 806}
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_average_number_of_goals_in_a_game_by_season
    expected = {"20122013" => 5.40}
    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_highest_total_score
    assert_equal 13, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_biggest_blowout
    assert_equal 7, @stat_tracker.biggest_blowout
  end

  def test_percentage_home_wins
    assert_equal 0.58, @stat_tracker.percentage_home_wins
  end

  def test_percentage_away_wins
    assert_equal 0.42, @stat_tracker.percentage_visitor_wins
  end

  def test_average_goals_per_game
    assert_equal 5.4, @stat_tracker.average_goals_per_game
  end

  def test_winningest_team
    assert_equal "Blackhawks", @stat_tracker.winningest_team
  end

  def test_best_fans
    assert_equal "Kings", @stat_tracker.best_fans
  end

  def test_worst_fans
    expected = ["Canadiens", "Islanders", "Maple Leafs", "Hurricanes", "Oilers"]
    assert_equal expected, @stat_tracker.worst_fans
  end

  def test_best_offense_league_stats
    assert_equal "Penguins", @stat_tracker.best_offense
  end

  def test_worst_offense_league_stats
    assert_equal "Predators", @stat_tracker.worst_offense
  end

  def test_best_defense_league_stats
    assert_equal "Blackhawks", @stat_tracker.best_defense
  end

  def test_worst_defense_league_stats
    assert_equal "Panthers", @stat_tracker.worst_defense
  end

  def test_count_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_can_find_highest_scoring_visitor
    expected = "Penguins"
    assert_equal expected, @stat_tracker.highest_scoring_visitor
  end

  def test_can_find_lowest_scoring_visitor
    expected = "Devils"
    assert_equal expected, @stat_tracker.lowest_scoring_visitor
  end

  def test_can_find_lowest_scoring_home_team
    expected = "Wild"
    assert_equal expected, @stat_tracker.lowest_scoring_home_team
  end

  def test_can_find_highest_scoring_home_team
    expected = "Lightning"
    assert_equal expected, @stat_tracker.highest_scoring_home_team
  end

  def test_most_goals_scored_by_team
    assert_equal 6, @stat_tracker.most_goals_scored("18")
  end

  def test_fewest_goals_scored_by_team
    assert_equal 0, @stat_tracker.fewest_goals_scored("18")
  end

  def test_head_to_head_by_team
    expected = {"Blues" => 0.25, "Avalanche" => 0.33,
      "Flames" => 0.67, "Red Wings" => 0.25, "Blue Jackets" => 0.2,
      "Stars" => 0.67, "Blackhawks" => 5, "Wild" => 0.33,
      "Canucks" => 3,"Sharks" => 0.67, "Oilers" => 0.67,
      "Ducks" => 3,"Kings" => 0.67,"Coyotes" => 0.33,
      }
    assert_equal expected, @stat_tracker.head_to_head("18")
  end

  def test_best_season
    assert_equal "20122013", @stat_tracker.best_season("6")
  end

  def test_worst_season
    assert_equal "20122013", @stat_tracker.worst_season("6")
  end

  def test_biggest_team_blowout
    assert_equal 6, @stat_tracker.biggest_team_blowout("18")
  end

  def test_worst_loss
    assert_equal 4, @stat_tracker.worst_loss("18")
  end

  def test_seasonal_summary
    expected = {
        "20122013" => {
          postseason: {
            :win_percentage=>0.0,
            :total_goals_scored=>0,
            :total_goals_against=>0,
            :average_goals_scored=>0.0,
            :average_goals_against=>0.0
          },
          :regular_season=>
          {
            :win_percentage=>0.33,
            :total_goals_scored=>111,
            :total_goals_against=>139,
            :average_goals_scored=>2.31,
            :average_goals_against=>2.9
          }
        }
      }
    assert_equal expected, @stat_tracker.seasonal_summary("18")
  end

  def test_it_can_return_team_info_by_team_id
    expected = {
      "team_id" => "4",
      "franchise_id" => "16",
      "short_name" => "Philadelphia",
      "team_name" => "Flyers",
      "abbreviation" => "PHI",
      "link" => "/api/v1/teams/4"
    }
    assert_equal expected, @stat_tracker.team_info("4")
  end

  def test_for_lowest_win_percentage_against_given_team
    assert_equal "Sharks", @stat_tracker.favorite_opponent("18")
  end

  def test_for_highest_win_percentage_against_given_team
    assert_equal "Ducks", @stat_tracker.rival("18")
  end

  def test_can_calculate_average_win_percentage
    assert_equal 0.33, @stat_tracker.average_win_percentage("18")
  end

  def test_biggest_bust
    assert_equal "Canucks", @stat_tracker.biggest_bust("20122013")
  end

  def test_biggest_surprise
    assert_equal "Sharks", @stat_tracker.biggest_surprise("20122013")
  end

  def test_most_accurate_team
    assert_equal "Lightning", @stat_tracker.most_accurate_team("20122013")
  end

  def test_least_accurate_team
    assert_equal "Senators", @stat_tracker.least_accurate_team("20122013")
  end

  def test_power_play_goal_percentage
    assert_equal 0.23, @stat_tracker.power_play_goal_percentage("20122013")
  end

  def test_most_hits_in_season
    assert_equal "Kings", @stat_tracker.most_hits("20122013")
  end

  def test_fewest_hits_in_season
    assert_equal "Devils", @stat_tracker.fewest_hits("20122013")
  end

  def test_can_return_the_worst_coach_of_season
    assert_equal "Martin Raymond", @stat_tracker.worst_coach("20122013")
  end

  def test_can_return_the_best_coach_of_season
    assert_equal "Dan Lacroix", @stat_tracker.winningest_coach("20122013")
  end
end
