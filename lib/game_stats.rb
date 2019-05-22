module GameStats

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
