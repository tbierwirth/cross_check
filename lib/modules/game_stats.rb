module GameStats

  def percentage_home_wins
    total_wins = @games.count do |game|
      game.outcome == ("home win REG") || game.outcome == ("home win OT") || game.outcome == ("home win SO")
    end
    ((total_wins.to_f / @games.count)).round(2)
  end

  def percentage_visitor_wins
    total_wins = @games.count do |game|
      game.outcome == ("away win REG") || game.outcome == ("away win OT") || game.outcome == ("away win SO")
    end
    ((total_wins.to_f / @games.count)).round(2)
  end

  def average_goals_per_game
    total = @games.sum do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    (total.to_f / @games.count).round(2)
  end

  def highest_total_score
    total_goals_for_all_games.max_by { |goals| goals }
  end

  def lowest_total_score
    total_goals_for_all_games.min_by { |goals| goals }
  end

  def total_goals_for_all_games
    @games.map do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
  end

  def biggest_blowout
    goal_differential = @games.map do |game|
      (game.away_goals.to_i - game.home_goals.to_i).abs
    end
    goal_differential.max_by { |goals| goals }
  end

  def count_of_games_by_season
    games_by_season = Hash.new(0)
    games.each do |game|
      games_by_season[game.season] += 1
    end
        games_by_season
  end

  def average_goals_by_season
    goals_by_season = Hash.new(0)
    games.each{|game| goals_by_season[game.season] += game.away_goals.to_i + game.home_goals.to_i}

    count_of_games_by_season.each{|season, game_count| goals_by_season[season] = (goals_by_season[season] / game_count.to_f).round(2)}

    goals_by_season
  end

end
