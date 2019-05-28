module SeasonStats

  def biggest_bust(season)
    reg_season_win_pct_matching_keys = reg_season_win_pct_by_team(season).reject do |team, value|
      !post_season_win_pct_by_team(season).keys.include? team
    end
    team_pct_diff_bust = reg_season_win_pct_matching_keys.merge(post_season_win_pct_by_team(season)) do |team, reg_pct, post_pct|
      (reg_pct - post_pct).abs.round(2)
    end
    worst_post_vs_reg = team_pct_diff_bust.max_by {|team, win_pct| win_pct}
    big_bust = @teams.find do |team|
      if team.team_id == worst_post_vs_reg[0]
        team.team_name
      end
    end
    big_bust.team_name
  end

  def biggest_surprise(season)
    reg_season_win_pct_matching_keys = reg_season_win_pct_by_team(season).reject do |team, value|
      !post_season_win_pct_by_team(season).keys.include? team
    end
    team_pct_diff_surprise = reg_season_win_pct_matching_keys.merge(post_season_win_pct_by_team(season)) do |team, reg_pct, post_pct|
      if post_pct > 1
        (reg_pct - post_pct).round(2)
      else
        (post_pct - reg_pct).round(2)
      end
    end
    best_post_vs_reg = team_pct_diff_surprise.max_by {|team, win_pct| win_pct}
    big_surprise = @teams.find do |team|
      if team.team_id == best_post_vs_reg[0]
        team.team_name
      end
    end
    big_surprise.team_name
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

end
