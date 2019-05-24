require "pry"
module LeagueStats

  def team_name(id)
    team = @teams.find do |team|
      id[0] == team.team_id
    end
    team.team_name
  end

  def total_games_played
    total_games_per_team = Hash.new(0)
    @games.each do |game|
      total_games_per_team[game.away_team_id] += 1
      total_games_per_team[game.home_team_id] += 1
    end
    total_games_per_team
  end

  def total_goals_made
    total_goals_made_per_team = Hash.new(0)
    @games.each do |game|
      total_goals_per_team[game.away_team_id] += game.away_goals.to_i
      total_goals_per_team[game.home_team_id] += game.home_goals.to_i
    end
    total_goals_made_per_team
  end

  def total_goals_allowed
    total_goals_allowed_per_team = Hash.new(0)
    @games.each do |game|
      total_goals_allowed_per_team[game.away_team_id] += game.home_goals.to_i
      total_goals_allowed_per_team[game.home_team_id] += game.away_goals.to_i
    end
    total_goals_allowed_per_team
  end

  def best_offense
    average = total_goals_made.merge(total_games_played) do |team_id, total_goals, games|
      total_goals / games.to_f
    end
    best_offense = average.max_by{ |team_id, goals| goals}
    team_name(best_offense)
  end

  def worst_offense
    average = total_goals_made.merge(total_games_played) do |team_id, total_goals, games|
      total_goals / games.to_f
    end
    worst_offense = average.min_by{ |team_id, goals| goals}
    team_name(worst_offense)
  end

  def best_defense
    average = total_goals_allowed.merge(total_games_played) do |team_id, total_goals, games|
      total_goals / games.to_f
    end
    best_defense = average.min_by{ |team_id, goals| goals}
    team_name(best_defense)
  end

  def worst_defense
    average = total_goals_allowed.merge(total_games_played) do |team_id, total_goals, games|
      total_goals / games.to_f
    end
    worst_defense = average.max_by{ |team_id, goals| goals}
    team_name(worst_defense)
  end

  def count_of_teams
    teams = []
    @teams.count do |team|
      teams << team.team_name
    end
    teams.uniq.count
  end

end
