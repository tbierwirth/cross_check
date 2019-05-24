module LeagueStats
  def highest_scoring_visitor
    total_away_goals_by_team_id = Hash.new(0)
      @games.each do |game|
        total_away_goals_by_team_id[game.away_team_id] += game.away_goals
    end

    total_away_games_by_team_id = Hash.new(0)
      @games.each do |game|
        total_away_games_by_team_id[game.away_team_id] += 1
    end

    average = total_away_goals_by_team_id.merge(total_away_games_by_team_id)  do |away_team, away_goals, away_games|
      away_goals / away_games.to_f
    end

    highest_average = average.max_by{|team_id, goals| goals}

    team = @teams.find do |team|
      highest_average.first == team.team_id
    end
    team.team_name
  end

  def lowest_scoring_visitor
    total_away_goals_by_team_id = Hash.new(0)
      @games.each do |game|
        total_away_goals_by_team_id[game.away_team_id] += game.away_goals
    end

    total_away_games_by_team_id = Hash.new(0)
      @games.each do |game|
        total_away_games_by_team_id[game.away_team_id] += 1
    end

    average = total_away_goals_by_team_id.merge(total_away_games_by_team_id) do |away_team, away_goals, away_games|
      away_goals / away_games.to_f
    end

    lowest_average = average.min_by{|team_id, goals| goals}

    team = @teams.find do |team|
      lowest_average.first == team.team_id
    end
    team.team_name
  end

def lowest_scoring_home_team
  total_home_goals_by_team_id = Hash.new(0)
    @games.each do |game|
      total_home_goals_by_team_id[game.home_team_id] += game.home_goals
  end

  total_home_games_by_team_id = Hash.new(0)
    @games.each do |game|
      total_home_games_by_team_id[game.home_team_id] += 1
  end

  average = total_home_goals_by_team_id.merge(total_home_games_by_team_id) do |home_team, home_goals, home_games|
    home_goals / home_games.to_f
  end

  lowest_average = average.min_by{|team_id, goals| goals}

  team = @teams.find do |team|
    lowest_average.first == team.team_id
  end
  team.team_name
end

def highest_scoring_home_team
  total_home_goals_by_team_id = Hash.new(0)
    @games.each do |game|
      total_home_goals_by_team_id[game.home_team_id] += game.home_goals
  end

  total_home_games_by_team_id = Hash.new(0)
    @games.each do |game|
      total_home_games_by_team_id[game.home_team_id] += 1
  end

  average = total_home_goals_by_team_id.merge(total_home_games_by_team_id) do |home_team, home_goals, home_games|
    home_goals / home_games.to_f
  end

  highest_average = average.max_by{|team_id, goals| goals}

  team = @teams.find do |team|
    highest_average.first == team.team_id
  end
  team.team_name
end

end
