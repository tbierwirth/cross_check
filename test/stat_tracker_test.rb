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

  def test_average_goals_by_season
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

  def test_highest_scoring_visitor
    expected = "Capitals"
    assert_equal expected, @stat_tracker.highest_scoring_visitor
  end

  def test_total_away_goals_by_team_id
    assert_equal ["3", 735], @stat_tracker.total_away_goals_by_team_id.first
  end

  def test_total_away_games_by_team_id
    assert_equal ["3", 266], @stat_tracker.total_away_games_by_team_id.first
  end

  def test_total_home_goals_by_team_id
    assert_equal ["6", 776], @stat_tracker.total_home_goals_by_team_id.first
  end

  def test_total_home_games_by_team_id
    assert_equal  ["6", 257], @stat_tracker.total_home_games_by_team_id.first
  end

  def test_lowest_scoring_visitor
    expected = "Sabres"
    assert_equal expected, @stat_tracker.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    expected = "Sabres"
    assert_equal expected, @stat_tracker.lowest_scoring_home_team
  end

  def test_highest_scoring_home_team
    expected = "Golden Knights"
    assert_equal expected, @stat_tracker.highest_scoring_home_team
  end

  def test_most_goals_scored_by_team
    assert_equal 9, @stat_tracker.most_goals_scored("18")
  end

  def test_fewest_goals_scored_by_team
    assert_equal 0, @stat_tracker.fewest_goals_scored("18")
  end

  def test_head_to_head_by_team
    expected = {"Blues" => 0.47, "Jets" => 0.55, "Avalanche" => 0.63,
      "Flames" => 0.44, "Red Wings" => 0.29, "Blue Jackets" => 0.6,
      "Stars" => 0.52, "Blackhawks" => 0.42, "Wild" => 0.44,
      "Devils" => 0.5, "Canadiens" => 0.6, "Canucks" => 0.5,
      "Rangers" => 0.4, "Lightning" => 0.7, "Capitals" => 0.7,
      "Sharks" => 0.6, "Oilers" => 0.78, "Ducks" => 0.48,
      "Penguins" => 0.31, "Islanders" => 0.4, "Kings" => 0.61,
      "Sabres" => 0.7, "Coyotes" => 0.67, "Bruins" => 0.5,
      "Panthers" => 0.5, "Maple Leafs" => 0.4, "Senators" => 0.7,
      "Hurricanes" => 0.3, "Golden Knights" => 0.33,"Flyers" => 0.5
      }
    assert_equal expected, @stat_tracker.head_to_head("18")
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

  def test_worst_loss
    assert_equal 6, @stat_tracker.worst_loss("18")
  end

  def test_seasonal_summary
    expected = {
      "20162017" => {
        postseason: {
          :win_percentage=>0.64,
          :total_goals_scored=>60,
          :total_goals_against=>48,
          :average_goals_scored=>2.73,
          :average_goals_against=>2.18},
          :regular_season => {
            :win_percentage=>0.5,
            :total_goals_scored=>240,
            :total_goals_against=>224,
            :average_goals_scored=>2.93,
            :average_goals_against=>2.73
          }
        },
        "20172018" => {
          postseason: {
            :win_percentage=>0.54,
            :total_goals_scored=>41,
            :total_goals_against=>42,
            :average_goals_scored=>3.15,
            :average_goals_against=>3.23
          },
          :regular_season=>
          {:win_percentage=>0.65,
            :total_goals_scored=>267,
            :total_goals_against=>211,
            :average_goals_scored=>3.26,
            :average_goals_against=>2.57
          }
        },
        "20132014" => {
          postseason: {
            :win_percentage=>0.0,
            :total_goals_scored=>0,
            :total_goals_against=>0,
            :average_goals_scored=>0.0,
            :average_goals_against=>0.0
          },
          :regular_season=>
          {
            :win_percentage=>0.46,
            :total_goals_scored=>216,
            :total_goals_against=>242,
            :average_goals_scored=>2.63,
            :average_goals_against=>2.95
          }
        },
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
        },
        "20142015" => {
          postseason: {
            :win_percentage=>0.33,
            :total_goals_scored=>21,
            :total_goals_against=>19,
            :average_goals_scored=>3.5,
            :average_goals_against=>3.17
          },
          :regular_season=>
          {
            :win_percentage=>0.57,
            :total_goals_scored=>232,
            :total_goals_against=>208,
            :average_goals_scored=>2.83,
            :average_goals_against=>2.54
          }
        },
        "20152016" => {
          postseason: {
            :win_percentage=>0.5,
            :total_goals_scored=>31,
            :total_goals_against=>43,
            :average_goals_scored=>2.21,
            :average_goals_against=>3.07
          },
          :regular_season=>
          {
            :win_percentage=>0.5,
            :total_goals_scored=>228,
            :total_goals_against=>215,
            :average_goals_scored=>2.78,
            :average_goals_against=>2.62
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
    assert_equal "Oilers", @stat_tracker.favorite_opponent("18")
  end

  def test_for_highest_win_percentage_against_given_team
    assert_equal "Red Wings", @stat_tracker.rival("18")
  end

  def test_can_calculate_average_win_percentage
    assert_equal 0.52, @stat_tracker.average_win_percentage("18")
  end

  def test_biggest_bust
    assert_equal "Lightning", @stat_tracker.biggest_bust("20132014")
    assert_equal "Jets", @stat_tracker.biggest_bust("20142015")
  end

  def test_biggest_surprise
    assert_equal "Kings", @stat_tracker.biggest_surprise("20132014")
    assert_equal "Blackhawks", @stat_tracker.biggest_surprise("20142015")
  end

  def test_most_accurate_team
    assert_equal "Ducks", @stat_tracker.most_accurate_team("20132014")
    assert_equal "Flames", @stat_tracker.most_accurate_team("20142015")
  end

  def test_least_accurate_team
    assert_equal "Sabres", @stat_tracker.least_accurate_team("20132014")
    assert_equal "Coyotes", @stat_tracker.least_accurate_team("20142015")
  end

  def test_power_play_goal_percentage
    assert_equal 0.22, @stat_tracker.power_play_goal_percentage("20132014")
    assert_equal 0.21, @stat_tracker.power_play_goal_percentage("20142015")
  end

  def test_most_hits_in_season
    assert_equal "Kings", @stat_tracker.most_hits("20132014")
    assert_equal "Islanders", @stat_tracker.most_hits("20142015")
  end

  def test_fewest_hits_in_season
    assert_equal "Devils", @stat_tracker.fewest_hits("20132014")
    assert_equal "Wild", @stat_tracker.fewest_hits("20142015")
  end

  def test_worst_coach
    assert_equal "Peter Laviolette", @stat_tracker.worst_coach("20132014")
    assert_equal "Craig MacTavish", @stat_tracker.worst_coach("20142015")
  end

  def test_winningest_coach
    assert_equal "Claude Julien", @stat_tracker.winningest_coach("20132014")
    assert_equal "Alain Vigneault", @stat_tracker.winningest_coach("20142015")
  end

  def test_games_lost
    assert_equal ["Joel Quenneville", 44], @stat_tracker.games_lost("20132014").first
  end

  def test_games_played
    assert_equal ["Joel Quenneville", 101], @stat_tracker.games_played("20132014").first
  end

  def test_win_percentage
    expected = ["Joel Quenneville", 0.5643564356435644]
    assert_equal expected, @stat_tracker.win_percentage("20132014").first
  end

end
