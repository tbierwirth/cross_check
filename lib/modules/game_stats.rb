module GameStats

  def percentage_home_wins
    total_wins = @games.count do |game|
      game.outcome == ("home win REG") || game.outcome == ("home win OT")
    end
    win_percentage = ((total_wins.to_f / @games.count) * 100.00).round(2)
  end

  def percentage_visitor_wins
    total_wins = @games.count do |game|
      game.outcome == ("away win REG") || game.outcome == ("away win OT")
    end
    win_percentage = ((total_wins.to_f / @games.count) * 100.00).round(2)
  end

  def average_goals_per_game
    total = @games.sum do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    (total.to_f / @games.count).round(2)
  end

  def highest_total_score
    total_goals = @games.map do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    total_goals.max_by { |goals| goals }
  end

  def lowest_total_score
    total_goals = @games.map do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    total_goals.min_by { |goals| goals }
  end

  def biggest_blowout
    goal_differential = @games.map do |game|
      (game.away_goals.to_i - game.home_goals.to_i).abs
    end
    goal_differential.max_by { |goals| goals }
  end

end
