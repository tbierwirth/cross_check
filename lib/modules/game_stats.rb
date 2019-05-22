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

  def count_of_games_by_season
    games_by_season = Hash.new(0)
      games.each do |game|
       games_by_season[game.season] += 1
      end
      games_by_season
   end

  def average_goals_by_season
    goals_by_season = Hash.new(0)
    games.each do |game|
      goals_by_season[game.season] += game.away_goals.to_i + game.home_goals.to_i
    end
    count_of_games_by_season.each do  |season, game_count|
      goals_by_season[season] = (goals_by_season[season] / game_count.to_f).round(2)
    end
    goals_by_season
  end

end
