require 'pry'
module GameStats

  def home_wins
    total_wins = @games.count do |game|
      game.outcome == ("home win REG") || game.outcome == ("home win OT")
    end
    win_percentage = ((total_wins.to_f / @games.count) * 100.00).round(2)
  end

end
