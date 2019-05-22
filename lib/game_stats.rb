module GameStats

  def highest_total_score
    total_goals = []
    @games.each do |game|
      total_goals << game.away_goals.to_i + game.home_goals.to_i
    end
    total_goals.max_by do |goals|
      goals
    end
  end

  def lowest_total_score
    total_goals = []
    @games.each do |game|
      total_goals << game.away_goals.to_i + game.home_goals.to_i
    end
    total_goals.min_by do |goals|
      goals
    end
  end

  def biggest_blowout
    goal_differential = []
    @games.each do |game|
      goal_differential << (game.away_goals.to_i - game.home_goals.to_i).abs
    end
    goal_differential.max_by do |goals|
      goals
    end
  end
end
