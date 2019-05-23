module LeagueStats

  def lowest_scoring_home_team
    home_goals_by_team = Hash.new(0)
    home_games_by_team = Hash.new(0)

    @game_team_stats.each do |game|
      if game.hoa == "home"
        home_goals_by_team[game.team_id] += game.goals.to_i
        home_games_by_team[game.team_id] += 1
      end
    end
    home_games_by_team.each do |team, games|
      home_goals_by_team[team] = (home_goals_by_team[team] / games.to_f).round(2)
    end
    lowest_scoring_team = home_goals_by_team.min_by {|team, avg_goals| avg_goals}
    lowest_home_team = @teams.find do |team|
      if team.team_id == lowest_scoring_team[0]
        team.team_name
      end
    end
    lowest_home_team.team_name
  end

  def lowest_scoring_visitor
    visitor_goals_by_team = Hash.new(0)
    visitor_games_by_team = Hash.new(0)

    @game_team_stats.each do |game|
      if game.hoa == "away"
        visitor_goals_by_team[game.team_id] += game.goals.to_i
        visitor_games_by_team[game.team_id] += 1
      end
    end
    visitor_games_by_team.each do |team, games|
      visitor_goals_by_team[team] = (visitor_goals_by_team[team] / games.to_f).round(2)
    end
    lowest_scoring_team = visitor_goals_by_team.min_by {|team, avg_goals| avg_goals}
    lowest_visitor_team = @teams.find do |team|
      if team.team_id == lowest_scoring_team[0]
        team.team_name
      end
    end
    lowest_visitor_team.team_name
  end

  def winningest_team
    total_wins_by_team = Hash.new(0)
    games_by_team = Hash.new(0)
    @game_team_stats.each do |game|
      games_by_team[game.team_id] += 1
    end

    @game_team_stats.each do |game|
      if game.won == "TRUE"
        total_wins_by_team[game.team_id] += 1
      end
    end

    games_by_team.each do |team, games|
      total_wins_by_team[team] = (total_wins_by_team[team] / games.to_f).round(2)
    end
    best_team = total_wins_by_team.max_by {|team, win_pct| win_pct}
    best_win_pct_team = @teams.find do |team|
      if team.team_id == best_team[0]
        team.team_name
      end
    end
    best_win_pct_team.team_name
  end

end
