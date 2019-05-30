module SeasonStats

  def biggest_bust(season)
    team_pct_diff_bust = post_season_teams(season).merge(post_season_win_pct_by_team(season)) do |team, reg_pct, post_pct|
      (reg_pct - post_pct).abs.round(2)
    end
    worst_post_vs_reg = team_pct_diff_bust.max_by {|team, win_pct| win_pct}
    team_name(worst_post_vs_reg)
  end

  def biggest_surprise(season)
    team_pct_diff_surprise = post_season_teams(season).merge(post_season_win_pct_by_team(season)) do |team, reg_pct, post_pct|
      if post_pct > 1
        (reg_pct - post_pct).round(2)
      else
        (post_pct - reg_pct).round(2)
      end
    end
    best_post_vs_reg = team_pct_diff_surprise.max_by {|team, win_pct| win_pct}
    team_name(best_post_vs_reg)
  end

  def post_season_teams(season)
    reg_season_win_pct_by_team(season).reject do |team, value|
      !post_season_win_pct_by_team(season).keys.include? team
    end
  end

  def reg_wins_by_team(season)
    reg_wins_by_team = Hash.new(0)
    @games.each do |game|
      if game.season == season && game.outcome.include?("away win") && game.type == "R"
        reg_wins_by_team[game.away_team_id] += 1
      elsif game.season == season && game.outcome.include?("home win") && game.type == "R"
        reg_wins_by_team[game.home_team_id] += 1
      end
    end
    reg_wins_by_team
  end

  def post_wins_by_team(season)
    post_wins_by_team = Hash.new(0)
    @games.each do |game|
      if game.season == season && game.outcome.include?("away win") && game.type == "P"
        post_wins_by_team[game.away_team_id] += 1
      elsif game.season == season && game.outcome.include?("home win") && game.type == "P"
        post_wins_by_team[game.home_team_id] += 1
      end
    end
    post_wins_by_team
  end

  def reg_season_games_by_team(season)
    reg_games_by_team = Hash.new(0)
    games.each do |game|
      if (game.season == season && game.type == "R")
        reg_games_by_team[game.home_team_id] += 1
        reg_games_by_team[game.away_team_id] += 1
      end
    end
    reg_games_by_team
  end

  def post_season_games_by_team(season)
    post_games_by_team = Hash.new(0)
    games.each do |game|
      if (game.season == season && game.type == "P")
        post_games_by_team[game.home_team_id] += 1
        post_games_by_team[game.away_team_id] += 1
      end
    end
    post_games_by_team
  end

  def reg_season_win_pct_by_team(season)
    reg_season = reg_wins_by_team(season).merge(reg_season_games_by_team(season)) do |season, wins, games|
      (wins / games.to_f).round(2)
    end
    reg_season
  end

  def post_season_win_pct_by_team(season)
    post_season = post_wins_by_team(season).merge(post_season_games_by_team(season)) do |team, wins, games|
        (wins / games.to_f).round(2)
    end
    post_season
  end

  def get_game_ids(season_id)
    game_ids = []
    @games.each do |game|
      if game.season == season_id
        game_ids << game.game_id
      end
    end
    game_ids
  end

  def most_accurate_team(season_id)
    team_shots = Hash.new(0)
    team_goals = Hash.new(0)
    game_ids = get_game_ids(season_id)
    @game_team_stats.each do |game|
      game_ids.each do |id|
        if game.game_id == id
          team_shots[name(game.team_id)] += game.shots.to_i
          team_goals[name(game.team_id)] += game.goals.to_i
        end
      end
    end
    accuracy = team_goals.merge(team_shots) do |name, goals, shots|
      goals.to_f / shots.to_f
    end
    (accuracy.max_by{|name, accuracy| accuracy})[0]
  end

  def least_accurate_team(season_id)
    team_shots = Hash.new(0)
    team_goals = Hash.new(0)
    game_ids = get_game_ids(season_id)
    @game_team_stats.each do |game|
      game_ids.each do |id|
        if game.game_id == id
          team_shots[name(game.team_id)] += game.shots.to_i
          team_goals[name(game.team_id)] += game.goals.to_i
        end
      end
    end
    accuracy = team_goals.merge(team_shots) do |name, goals, shots|
      goals.to_f / shots.to_f
    end
    (accuracy.min_by{|name, accuracy| accuracy})[0]
  end

  def power_play_goal_percentage(season_id)
    game_ids = get_game_ids(season_id)
    goals = 0
    power_play_goals = 0
    @game_team_stats.each do |game|
      game_ids.each do |id|
        if game.game_id == id
          goals += game.goals.to_i
          power_play_goals += game.power_play_goals.to_i
        end
      end
    end
    (power_play_goals / goals.to_f).round(2)
  end

  def most_hits(season_id)
    game_ids = get_game_ids(season_id)
    teams = Hash.new(0)
    @game_team_stats.each do |game|
      game_ids.each do |id|
        if game.game_id == id
          teams[name(game.team_id)] += game.hits.to_i
        end
      end
    end
    (teams.max_by{|name, hits| hits})[0]
  end

  def fewest_hits(season_id)
    game_ids = get_game_ids(season_id)
    teams = Hash.new(0)
    @game_team_stats.each do |game|
      game_ids.each do |id|
        if game.game_id == id
          teams[name(game.team_id)] += game.hits.to_i
        end
      end
    end
    (teams.min_by{|name, hits| hits})[0]
  end

  def worst_coach(season)
    worst_percentage = win_percentage(season).min_by{|coach, percentage| percentage}
    worst_percentage.first
  end

  def winningest_coach(season)
    best_percentage = win_percentage(season).max_by{|coach, percentage| percentage}
    best_percentage.first
  end

  def games_lost(season)
    games_lost = Hash.new(0)
    relevant_game_id = get_game_ids(season)
    @game_team_stats.find_all do |game|
      relevant_game_id.find_all do |id|
        if id == game.game_id && game.won == "FALSE"
          games_lost[game.head_coach] += 1
        end
      end
    end
    games_lost
  end

  def games_played(season)
    games_played = Hash.new(0)
    relevant_game_id = get_game_ids(season)
    @game_team_stats.find_all do |game|
      relevant_game_id.find_all do |id|
       if id == game.game_id
         games_played[game.head_coach] += 1
        end
      end
    end
    games_played
  end

  def win_percentage(season)
    win_percentage = games_lost(season).merge(games_played(season)){|coach, lost, played| 1 - (lost / played.to_f)}
  end

end
