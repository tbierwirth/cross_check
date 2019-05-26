require "pry"
module TeamStats

  def most_goals_scored(id)
    goals = []
    @games.select do |game|
      if game.away_team_id == id
        goals << game.away_goals
      elsif game.home_team_id == id
        goals << game.home_goals
      end
    end
    goals.max
  end

  def fewest_goals_scored(id)
    goals = []
    @games.select do |game|
      if game.away_team_id == id
        goals << game.away_goals
      elsif game.home_team_id == id
        goals << game.home_goals
      end
    end
    goals.min
  end

end
