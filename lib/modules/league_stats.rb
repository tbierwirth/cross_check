require "pry"
module LeagueStats

  def best_offense
    average_goals_per_team = Hash.new(0)
    total_games_per_team = Hash.new(0)
    @game_team_stats.each do |game|
      average_goals_per_team[game.team_id] +=
      (game.goals.to_i / total_games_per_team[game.team_id] += 1)
    end
    highest_average = average_goals_per_team.max_by{ |team_id, goals| goals}
    team = @teams.find do |team|
      highest_average[0] == team.team_id
    end
    team.team_name
  end

end
