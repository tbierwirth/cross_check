
module LeagueStats

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

  def best_fans
    winning_pct_diff = home_win_pct_by_team.merge(away_win_pct_by_team) do |team, home_pct, away_pct|
      home_pct - away_pct
    end
    best_team_fans = winning_pct_diff.max_by {|team, pct_diff| pct_diff}
    best_fans = @teams.find do |team|
      team.team_id == best_team_fans[0]
    end
    best_fans.team_name
  end

  def worst_fans
    the_worst = []
    home_win_pct_by_team.each do |team, win_pct|
        if away_win_pct_by_team[team] > win_pct
          the_worst << team
        end
    end
    the_worst
  end

  def home_wins_by_team
    home_wins_by_team = Hash.new(0)
    @game_team_stats.each do |game|
      if game.won == "TRUE" && game.hoa == "home"
        home_wins_by_team[game.team_id] += 1
      end
    end
    home_wins_by_team
  end

  def away_wins_by_team
    away_wins_by_team = Hash.new(0)
    @game_team_stats.each do |game|
      if game.won == "TRUE" && game.hoa == "away"
        away_wins_by_team[game.team_id] += 1
      end
    end
    away_wins_by_team
  end

  def games_by_team_game_team_stats
    games_by_team = Hash.new(0)
    @game_team_stats.each do |game|
      games_by_team[game.team_id] += 1
    end
    games_by_team
  end

  def away_games_by_team
    away_games_by_team = Hash.new(0)
    @game_team_stats.each do |game|
      if game.hoa == "away"
        away_games_by_team[game.team_id] += 1
      end
    end
    away_games_by_team
  end

  def home_games_by_team
    home_games_by_team = Hash.new(0)
    @game_team_stats.each do |game|
      if game.hoa == "home"
        home_games_by_team[game.team_id] += 1
      end
    end
    home_games_by_team
  end

  def home_win_pct_by_team
    home_win_pct = home_wins_by_team
    home_games_by_team.each do |team, games|
      home_win_pct[team] = (home_win_pct[team] / games.to_f)
    end
    home_win_pct
  end

  def away_win_pct_by_team
    away_win_pct = away_wins_by_team
    away_games_by_team.each do |team, games|
      away_win_pct[team] = (away_win_pct[team] / games.to_f)
    end
    away_win_pct
  end

  def team_name(id)
    team = @teams.find do |team|
      id[0] == team.team_id
    end
    team.team_name
  end

  def total_games_played_game_stats
    total_games_per_team = Hash.new(0)
    @games.each do |game|
      total_games_per_team[game.away_team_id] += 1
      total_games_per_team[game.home_team_id] += 1
    end
    total_games_per_team
  end

  def total_goals_made
    total_goals_made_per_team = Hash.new(0)
    @games.each do |game|
      total_goals_made_per_team[game.away_team_id] += game.away_goals.to_i
      total_goals_made_per_team[game.home_team_id] += game.home_goals.to_i
    end
    total_goals_made_per_team
  end

  def total_goals_allowed
    total_goals_allowed_per_team = Hash.new(0)
    @games.each do |game|
      total_goals_allowed_per_team[game.away_team_id] += game.home_goals.to_i
      total_goals_allowed_per_team[game.home_team_id] += game.away_goals.to_i
    end
    total_goals_allowed_per_team
  end

  def best_offense
    average = total_goals_made.merge(total_games_played) do |team_id, total_goals, games|
      total_goals / games.to_f
    end
    best_offense = average.max_by{ |team_id, goals| goals}
    team_name(best_offense)
  end

  def worst_offense
    average = total_goals_made.merge(total_games_played) do |team_id, total_goals, games|
      total_goals / games.to_f
    end
    worst_offense = average.min_by{ |team_id, goals| goals}
    team_name(worst_offense)
  end

  def best_defense
    average = total_goals_allowed.merge(total_games_played) do |team_id, total_goals, games|
      total_goals / games.to_f
    end
    best_defense = average.min_by{ |team_id, goals| goals}
    team_name(best_defense)
  end

  def worst_defense
    average = total_goals_allowed.merge(total_games_played) do |team_id, total_goals, games|
      total_goals / games.to_f
    end
    worst_defense = average.max_by{ |team_id, goals| goals}
    team_name(worst_defense)
  end

  def count_of_teams
    teams = []
    @teams.count do |team|
      teams << team.team_name
    end
    teams.uniq.count
  end
end
