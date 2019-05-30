require 'simplecov'
SimpleCov.start
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

  def test_average_number_of_goals_by_season
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

  def test_total_away_goals_by_team_id
    assert_equal ["3", 65], @stat_tracker.total_away_goals_by_team_id.first
  end

  def test_total_away_games_by_team_id
    assert_equal ["3", 31], @stat_tracker.total_away_games_by_team_id.first
  end

  def test_total_home_goals_by_team_id
    assert_equal ["6", 106], @stat_tracker.total_home_goals_by_team_id.first
  end

  def test_total_home_games_by_team_id
    assert_equal  ["6", 36], @stat_tracker.total_home_games_by_team_id.first
  end

  def test_highest_scoring_visitor
    expected = "Penguins"
    assert_equal expected, @stat_tracker.highest_scoring_visitor
  end

  def test_lowest_scoring_visitor
    expected = "Devils"
    assert_equal expected, @stat_tracker.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    expected = "Wild"
    assert_equal expected, @stat_tracker.lowest_scoring_home_team
  end

  def test_highest_scoring_home_team
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

  def test_team_info
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

  def test_favorite_opponent
    assert_equal "Sharks", @stat_tracker.favorite_opponent("18")
  end

  def test_relevant_games
    assert_equal "Ducks", @stat_tracker.rival("18")
  end

  def test_average_win_percentage
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

  def test_games_lost
    assert_equal ["John Tortorella", 29], @stat_tracker.games_lost("20122013").first
  end

  def test_games_played
    assert_equal ["John Tortorella", 60], @stat_tracker.games_played("20122013").first
  end

  def test_win_percentage
    expected = ["John Tortorella", 0.5166666666666666]
    assert_equal expected, @stat_tracker.win_percentage("20122013").first
  end

  def test_total_goals_for_all_games
    assert_equal 4351, @stat_tracker.total_goals_for_all_games.sum
  end

  def test_total_wins_by_team
    expected = {"6"=>42, "3"=>31, "16"=>52, "17"=>31, "8"=>30, "9"=>30, "30"=>27, "19"=>31, "26"=>36, "24"=>33, "5"=>44, "2"=>26, "15"=>30, "29"=>25, "27"=>21, "10"=>29, "1"=>19, "18"=>16, "4"=>23, "52"=>24, "25"=>22, "7"=>21, "28"=>33, "13"=>15, "22"=>19, "23"=>26, "20"=>19, "21"=>16, "14"=>18, "12"=>19}
    assert_equal expected, @stat_tracker.total_wins_by_team
  end

  def test_games_by_team_game_team_stats
    expected = {"3"=>60, "6"=>70, "5"=>63, "17"=>63, "16"=>71, "9"=>58, "8"=>53, "30"=>53, "26"=>66, "19"=>54, "24"=>55, "2"=>54, "15"=>55, "29"=>49, "12"=>48, "1"=>48, "27"=>48, "7"=>48, "20"=>48, "21"=>48, "22"=>48, "10"=>55, "13"=>48, "28"=>60, "18"=>48, "52"=>48, "4"=>48, "25"=>48, "23"=>52, "14"=>48}
    assert_equal expected, @stat_tracker.games_by_team_game_team_stats
  end

  def test_team_name_converter
    assert_equal "Blackhawks", @stat_tracker.team_name(["16",5])
  end

  def test_win_pct_by_season_for_specific_team
    expected = {"20122013"=>0.7323943661971831}
    assert_equal expected, @stat_tracker.win_pct_by_season("16")
  end

  def test_wins_by_season_for_specific_team
    expected = {"20122013"=>52}
    assert_equal expected, @stat_tracker.wins_by_season("16")
  end

  def test_count_of_team_games_by_season_for_specific_team
    expected = {"20122013"=>71}
    assert_equal expected, @stat_tracker.count_of_team_games_by_season("16")
  end

  def test_post_season_games_for_specific_team
    expected = {"20122013"=>23}
    assert_equal expected, @stat_tracker.post_season_games("16")
  end

  def test_reg_season_games_for_specific_team
    expected = {"20122013"=>48}
    assert_equal expected, @stat_tracker.reg_season_games("16")
  end

  def test_only_post_season_teams_are_included
    expected = {"24"=>0.63, "6"=>0.58, "30"=>0.54, "15"=>0.56, "16"=>0.75, "17"=>0.5, "10"=>0.54, "2"=>0.5, "19"=>0.6, "23"=>0.54, "26"=>0.56, "5"=>0.75, "8"=>0.6, "9"=>0.52, "28"=>0.52, "3"=>0.54}
    assert_equal expected, @stat_tracker.post_season_teams("20122013")
  end

  def test_reg_wins_by_team_for_season
    expected = {"24"=>30, "6"=>28, "1"=>19, "27"=>21, "30"=>26, "15"=>27, "16"=>36, "17"=>24, "22"=>19, "10"=>26, "2"=>24, "19"=>29, "18"=>16, "7"=>21, "4"=>23, "52"=>24, "25"=>22, "23"=>26, "26"=>27, "14"=>18, "5"=>36, "8"=>29, "9"=>25, "13"=>15, "29"=>24, "28"=>25, "12"=>19, "3"=>26, "21"=>16, "20"=>19}
    assert_equal expected, @stat_tracker.reg_wins_by_team("20122013")
  end

  def test_reg_games_by_team_for_season
    expected = {"24"=>48, "29"=>48, "6"=>48, "12"=>48, "2"=>48, "1"=>48, "27"=>48, "26"=>48, "30"=>48, "7"=>48, "15"=>48, "20"=>48, "16"=>48, "17"=>48, "21"=>48, "22"=>48, "10"=>48, "13"=>48, "28"=>48, "19"=>48, "9"=>48, "18"=>48, "4"=>48, "52"=>48, "25"=>48, "23"=>48, "8"=>48, "14"=>48, "5"=>48, "3"=>48}
    assert_equal expected, @stat_tracker.reg_season_games_by_team("20122013")
  end

  def test_post_wins_by_team_for_season
    expected = {"6"=>14, "3"=>5, "16"=>16, "17"=>7, "9"=>5, "8"=>1, "30"=>1, "19"=>2, "26"=>9, "24"=>3, "5"=>8, "2"=>2, "15"=>3, "10"=>3, "28"=>7}
    assert_equal expected, @stat_tracker.post_wins_by_team("20122013")
  end

  def test_post_games_by_team_for_season
    expected = {"6"=>22, "3"=>12, "5"=>15, "16"=>23, "17"=>14, "8"=>5, "9"=>10, "30"=>5, "19"=>6, "26"=>18, "24"=>7, "2"=>6, "15"=>7, "10"=>7, "28"=>11, "23"=>4}
    assert_equal expected, @stat_tracker.post_season_games_by_team("20122013")
  end

  def test_reg_win_pct_by_team_for_season
    expected = {"24"=>0.63, "6"=>0.58, "1"=>0.4, "27"=>0.44, "30"=>0.54, "15"=>0.56, "16"=>0.75, "17"=>0.5, "22"=>0.4, "10"=>0.54, "2"=>0.5, "19"=>0.6, "18"=>0.33, "7"=>0.44, "4"=>0.48, "52"=>0.5, "25"=>0.46, "23"=>0.54, "26"=>0.56, "14"=>0.38, "5"=>0.75, "8"=>0.6, "9"=>0.52, "13"=>0.31, "29"=>0.5, "28"=>0.52, "12"=>0.4, "3"=>0.54, "21"=>0.33, "20"=>0.4}
    assert_equal expected, @stat_tracker.reg_season_win_pct_by_team("20122013")
  end

  def test_post_win_pct_by_team_for_season
    expected = {"6"=>0.64, "3"=>0.42, "16"=>0.7, "17"=>0.5, "9"=>0.5, "8"=>0.2, "30"=>0.2, "19"=>0.33, "26"=>0.5, "24"=>0.43, "5"=>0.53, "2"=>0.33, "15"=>0.43, "10"=>0.43, "28"=>0.64, "23"=>4}
    assert_equal expected, @stat_tracker.post_season_win_pct_by_team("20122013")
  end

  def test_reg_win_pct_by_season_for_team
    expected = {"20122013"=>0.75}
    assert_equal expected, @stat_tracker.reg_season_win_percentage("16")
  end

  def test_post_win_pct_by_season_for_team
    expected = {"20122013"=>0.7}
    assert_equal expected, @stat_tracker.post_season_win_percentage("16")
  end
end
