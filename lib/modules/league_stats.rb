require "pry"
module LeagueStats

  def best_offense
    total_goals_per_team = Hash.new(0)
    total_games_per_team = Hash.new(0)
    @games.each do |game|
      total_goals_per_team[game.away_team_id] += game.away_goals.to_i
      total_goals_per_team[game.home_team_id] += game.home_goals.to_i
    end
    @games.each do |game|
      total_games_per_team[game.away_team_id] += 1
      total_games_per_team[game.home_team_id] += 1
    end
    average = total_goals_per_team.merge(total_games_per_team) do |team_id, total_goals, games|
      total_goals / games.to_f
    end
    highest_average = average.max_by{ |team_id, goals| goals}
    team = @teams.find do |team|
      highest_average[0] == team.team_id
    end
    team.team_name
  end

  def worst_offense
    total_goals_per_team = Hash.new(0)
    total_games_per_team = Hash.new(0)
    @games.each do |game|
      total_goals_per_team[game.away_team_id] += game.away_goals.to_i
      total_goals_per_team[game.home_team_id] += game.home_goals.to_i
    end
    @games.each do |game|
      total_games_per_team[game.away_team_id] += 1
      total_games_per_team[game.home_team_id] += 1
    end
    average = total_goals_per_team.merge(total_games_per_team) do |team_id, total_goals, games|
      total_goals / games.to_f
    end
    highest_average = average.min_by{ |team_id, goals| goals}
    team = @teams.find do |team|
      highest_average[0] == team.team_id
    end
    team.team_name
  end

end
