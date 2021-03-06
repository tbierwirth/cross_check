module TeamStats

  def goals_scored(id)
    goals = []
    @games.map do |game|
      if game.away_team_id == id
        goals << game.away_goals
      elsif game.home_team_id == id
        goals << game.home_goals
      end
    end
    goals
  end

  def most_goals_scored(id)
    goals_scored(id).max
  end

  def fewest_goals_scored(id)
    goals_scored(id).min
  end

  def team_games_played(id)
    games = Hash.new(0)
    @games.map do |game|
      if game.away_team_id == id
        games[game.home_team_id] += 1
      else game.home_team_id == id
        games[game.away_team_id] += 1
      end
    end
    games
  end

  def team_games_won(id)
    wins = Hash.new(0)
    @games.map do |game|
      if game.outcome.include?("away win")
        wins[game.home_team_id] += 1
      else game.outcome.include?("home win")
          wins[game.away_team_id] += 1
      end
    end
    wins
  end

  def head_to_head(id)
    wins = Hash.new(0)
    games = Hash.new(0)
    @games.each do |game|
      if game.away_team_id == id
        games[game.home_team_id] += 1
        if game.outcome.include?("away win")
          wins[game.home_team_id] += 1
        end
      elsif game.home_team_id == id
        games[game.away_team_id] += 1
        if game.outcome.include?("home win")
          wins[game.away_team_id] += 1
        end
      end
    end
    percentages = games.merge(wins) do |team_id, games, wins|
      (wins / games.to_f).round(2)
    end
    result = {}
    percentages.each_pair do |team_id, percentage|
      result[name(team_id)] = percentage
    end
    result
  end

  def name(id)
    team = @teams.find do |team|
      id == team.team_id
    end
    team.team_name
  end

  def best_season(team_id)
    best_season = win_pct_by_season(team_id).max_by {|season, win_pct| win_pct}
    best_season.first
  end

  def worst_season(team_id)
    worst_season = win_pct_by_season(team_id).min_by {|season, win_pct| win_pct}
    worst_season.first
  end

  def win_pct_by_season(team_id)
    count_of_team_games_by_season(team_id)
    wins_by_season(team_id)
    win_pct_season = wins_by_season(team_id).merge(count_of_team_games_by_season(team_id)) do |season, wins, games|
      wins / games.to_f
    end
    win_pct_season
  end

  def count_of_team_games_by_season(team_id)
    games_by_season = reg_season_games(team_id).merge(post_season_games(team_id)) do |games, reg, post|
      post + reg
    end
    games_by_season
  end

  def reg_season_games(team_id)
    reg_games_by_season = Hash.new(0)
    games.each do |game|
      if (game.away_team_id == team_id || game.home_team_id == team_id) && game.type == "R"
        reg_games_by_season[game.season] += 1
      end
    end
    reg_games_by_season
  end

  def post_season_games(team_id)
    post_games_by_season = Hash.new(0)
    games.each do |game|
      if (game.away_team_id == team_id || game.home_team_id == team_id) && game.type == "P"
        post_games_by_season[game.season] += 1
      end
    end
    post_games_by_season
  end

  def wins_by_season(team_id)
    wins_by_season = reg_wins_by_season(team_id).merge(post_wins_by_season(team_id)) do |wins, reg, post|
      post + reg
    end
    wins_by_season
  end

  def reg_wins_by_season(team_id)
    reg_wins_by_season = Hash.new(0)
    @games.each do |game|
      if game.away_team_id == team_id && game.outcome.include?("away win") && game.type == "R"
        reg_wins_by_season[game.season] += 1
      elsif game.home_team_id == team_id && game.outcome.include?("home win") && game.type == "R"
        reg_wins_by_season[game.season] += 1
      end
    end
    reg_wins_by_season
  end

  def post_wins_by_season(team_id)
    post_wins_by_season = Hash.new(0)
    @games.each do |game|
      if game.away_team_id == team_id && game.outcome.include?("away win") && game.type == "P"
        post_wins_by_season[game.season] += 1
      elsif game.home_team_id == team_id && game.outcome.include?("home win") && game.type == "P"
        post_wins_by_season[game.season] += 1
      end
    end
    post_wins_by_season
  end

  def biggest_team_blowout(team_id)
    big_blowout = Hash.new(0)
    @games.each do |game|
      if game.home_team_id == team_id && game.outcome.include?("home win")
        big_blowout[game.game_id] += (game.home_goals.to_i - game.away_goals.to_i)
      elsif game.away_team_id == team_id && game.outcome.include?("away win")
        big_blowout[game.game_id] += (game.away_goals.to_i - game.home_goals.to_i)
      end
    end
    big_blowout.max_by {|game, goal_diff| goal_diff}.last
  end

  def worst_loss(team_id)
    bad_loss = Hash.new(0)
    @games.each do |game|
      if game.home_team_id == team_id && game.outcome.include?("away win")
        bad_loss[game.game_id] += (game.away_goals.to_i - game.home_goals.to_i)
      elsif game.away_team_id == team_id && game.outcome.include?("home win")
        bad_loss[game.game_id] += (game.home_goals.to_i - game.away_goals.to_i)
      end
    end
    bad_loss.max_by {|game, goal_diff| goal_diff}.last
  end

  def seasonal_summary(team_id)
    season_summary = {}
    rswp = reg_season_win_percentage(team_id)
    pswp = post_season_win_percentage(team_id)
    reg_goals = reg_season_goals(team_id)
    post_goals = post_season_goals(team_id)
    reg_goals_against = reg_season_goals_against(team_id)
    post_goals_against = post_season_goals_against(team_id)
    reg_goals_avg = reg_season_goals_average(team_id)
    post_goals_avg = post_season_goals_average(team_id)
    reg_goals_against_avg = reg_goals_against_average(team_id)
    post_goals_against_avg = post_goals_against_average(team_id)

    @games.each do |game|
        season_summary[game.season] = Hash.new
        season_summary[game.season][:regular_season] = Hash.new
        season_summary[game.season][:regular_season][:win_percentage] = rswp[game.season]
        season_summary[game.season][:regular_season][:total_goals_scored] = reg_goals[game.season]
        season_summary[game.season][:regular_season][:total_goals_against] = reg_goals_against[game.season]
        season_summary[game.season][:regular_season][:average_goals_scored] = reg_goals_avg[game.season]
        season_summary[game.season][:regular_season][:average_goals_against] = reg_goals_against_avg[game.season]
    end

    @games.each do |game|
      season_summary[game.season][:postseason] = Hash.new
      season_summary[game.season][:postseason][:win_percentage] = pswp[game.season]
      season_summary[game.season][:postseason][:total_goals_scored] = post_goals[game.season]
      season_summary[game.season][:postseason][:total_goals_against] = post_goals_against[game.season]
      season_summary[game.season][:postseason][:average_goals_scored] = post_goals_avg[game.season]
      season_summary[game.season][:postseason][:average_goals_against] = post_goals_against_avg[game.season]
    end
    season_summary
  end

  def reg_season_win_percentage(team_id)
    reg_season_win_pct = reg_wins_by_season(team_id).merge(reg_season_games(team_id)) do |team, wins, games|
      (wins / games.to_f).round(2)
    end
    reg_season_win_pct
  end

  def post_season_win_percentage(team_id)
    post_season_win_pct = post_wins_by_season(team_id).merge(post_season_games(team_id)) do |team, wins, games|
      (wins / games.to_f).round(2)
    end
    post_season_win_pct
  end

  def reg_season_goals(team_id)
    reg_season_goals = Hash.new(0)
    @games.each do |game|
      if game.home_team_id == team_id && game.type == "R"
        reg_season_goals[game.season] += game.home_goals.to_i
      elsif game.away_team_id == team_id && game.type == "R"
        reg_season_goals[game.season] += game.away_goals.to_i
      end
    end
    reg_season_goals
  end

  def post_season_goals(team_id)
    post_season_goals = Hash.new(0)
    @games.each do |game|
      if game.home_team_id == team_id && game.type == "P"
        post_season_goals[game.season] += game.home_goals.to_i
      elsif game.away_team_id == team_id && game.type == "P"
        post_season_goals[game.season] += game.away_goals.to_i
      end
    end
    post_season_goals
  end

  def reg_season_goals_average(team_id)
    avg_reg_season_goals = reg_season_goals(team_id).merge(reg_season_games(team_id)) do |season, goals, games|
      (goals / games.to_f).round(2)
    end
    avg_reg_season_goals
  end

  def post_season_goals_average(team_id)
    avg_post_season_goals = post_season_goals(team_id).merge(post_season_games(team_id)) do |season, goals, games|
      (goals / games.to_f).round(2)
    end
    avg_post_season_goals
  end

  def reg_season_goals_against(team_id)
    reg_season_goals = Hash.new(0)
    @games.each do |game|
      if game.home_team_id == team_id && game.type == "R"
        reg_season_goals[game.season] += game.away_goals.to_i
      elsif game.away_team_id == team_id && game.type == "R"
        reg_season_goals[game.season] += game.home_goals.to_i
      end
    end
    reg_season_goals
  end

  def post_season_goals_against(team_id)
    post_season_goals = Hash.new(0)
    @games.each do |game|
      if game.home_team_id == team_id && game.type == "P"
        post_season_goals[game.season] += game.away_goals.to_i
      elsif game.away_team_id == team_id && game.type == "P"
        post_season_goals[game.season] += game.home_goals.to_i
      end
    end
    post_season_goals
  end

  def reg_goals_against_average(team_id)
    reg_season_goals_against(team_id).merge(reg_season_games(team_id)) do |season, goals, games|
      (goals / games.to_f).round(2)
    end
  end

  def post_goals_against_average(team_id)
    post_season_goals_against(team_id).merge(post_season_games(team_id)) do |season, goals, games|
      (goals / games.to_f).round(2)
    end
  end

  def team_info(team_id)
    target_team = @teams.find do |team|
      team.team_id == team_id
    end
    target_team.instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete('@')] = target_team.instance_variable_get(var)
    end
  end

  def relevant_games(team_id)
    @games.find_all do |game|
      game.home_team_id == team_id || game.away_team_id == team_id
    end
  end

  def favorite_opponent(team_id)
    games_played = Hash.new(0)
    #{opponent_id => times opponent played target_team}
    wins = Hash.new(0)
    #{oppenent_id => times that target_team has won against opponent}
    relevant_games(team_id).map do |game|
      if team_id == game.home_team_id && game.home_goals > game.away_goals
        wins[team_id] += 1
      elsif team_id == game.home_team_id && game.home_goals < game.away_goals
        wins[game.away_team_id] += 1
      elsif team_id == game.away_team_id && game.home_goals < game.away_goals
        wins[team_id] += 1
      elsif team_id == game.away_team_id && game.home_goals > game.away_goals
        wins[game.home_team_id] += 1
      end
    end

    win_percentage = games_played.merge(wins) do |opponent_id, num_of_games, num_won|
      num_won / num_of_games.to_f
    end
    lowest_percentage = win_percentage.min_by do |id, percentage|
      percentage
    end
    team = @teams.find do |team|
      lowest_percentage.first == team.team_id
    end
    team.team_name
  end

  def games_against_opponent_count(team_id)
    games_played = Hash.new(0)
    #{opponent_id => times opponent played target_team}
    relevant_games(team_id).each do |game|
      if team_id == game.home_team_id
        opponent = game.away_team_id
        games_played[opponent] += 1
      else
        opponent = game.home_team_id
        games_played[opponent] += 1
      end
    end
    games_played
  end

  def opponent_team_wins(team_id)
    wins = Hash.new(0)
    #{oppenent_id => times that target_team has won against opponent}
    relevant_games(team_id).each do |game|
      if team_id == game.home_team_id && game.home_goals < game.away_goals
        wins[game.away_team_id] += 1
      elsif team_id == game.away_team_id && game.home_goals > game.away_goals
        wins[game.home_team_id] += 1
      end
    end
    wins
  end

  def rival(team_id)
    wins = opponent_team_wins(team_id)
    games_played = games_against_opponent_count(team_id)

    win_percentage = games_played.merge(wins) do |opponent_id, num_of_games, num_won|
      num_won / num_of_games.to_f
    end
    highest_percentage = win_percentage.max_by do |id, percentage|
      percentage
    end
    team = @teams.find do |team|
      highest_percentage.first == team.team_id
    end
    team.team_name
  end

  def average_win_percentage(team_id)
    wins = Hash.new(0)
    relevant_games(team_id).map do |game|
      if team_id == game.home_team_id && game.home_goals > game.away_goals
        wins[team_id] += 1
      elsif team_id == game.away_team_id && game.home_goals < game.away_goals
        wins[team_id] += 1
      end
    end
    win_percentage = wins[team_id].to_f / relevant_games(team_id).length
    win_percentage.round(2)
  end

end
