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
end
