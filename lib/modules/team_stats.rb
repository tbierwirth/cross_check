module TeamStats

  def team_info(team_id)
    #team_info returns key value pairs for each of the attributes of the team passed to it.
    target_team = @teams.find do |team|
      team.team_id == team_id
    end
    target_team.instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete('@')] = target_team.instance_variable_get(var)
    end
  end

  def favorite_opponent(team_id)
    #returns name of opponent that has lowest win % against given team
    relevant_games = @games.find_all do |game|
      game.home_team_id == team_id || game.away_team_id == team_id
    end

    games_played = Hash.new(0)
    #{opponent_id => times opponent played target_team}
    relevant_games.map do |game|
      if team_id == game.home_team_id
        opponent = game.away_team_id
        games_played[opponent] += 1
      else
        opponent = game.home_team_id
        games_played[opponent] += 1
      end
    end

    wins = Hash.new(0)
    #{oppenent_id => times that target_team has won against opponent}
    relevant_games.map do |game|
      if team_id == game.home_team_id && game.home_goals > game.away_goals
        wins[team_id] += 1
      elsif team_id == game.home_team_id && game.home_goals < game.away_goals
        wins[game.away_team_id] += 1
      elsif team_id == game.away_team_id && game.home_goals < game.away_goals
        wins[team_id] += 1
      elsif team_id == game.away_team_id && game.home_goals > game.away_goals
        wins[game.home_team_id] += 1
      end
    end

    win_percentage = games_played.merge(wins) do |opponent_id, num_of_games, num_won|
      num_won / num_of_games.to_f
    end
    lowest_percentage = win_percentage.min_by do |id, percentage|
      percentage
    end
    team = @teams.find do |team|
      lowest_percentage.first == team.team_id
    end
    team.team_name
  end

  def rival(team_id)
  #Name of the opponent that has the highest win percentage against the given team.
    relevant_games = @games.find_all do |game|
      game.home_team_id == team_id || game.away_team_id == team_id
    end

    games_played = Hash.new(0)
    #{opponent_id => times opponent played target_team}
    relevant_games.map do |game|
      if team_id == game.home_team_id
        opponent = game.away_team_id
        games_played[opponent] += 1
      else
        opponent = game.home_team_id
        games_played[opponent] += 1
      end
    end

    wins = Hash.new(0)
    #{oppenent_id => times that target_team has won against opponent}
    relevant_games.map do |game|
      if team_id == game.home_team_id && game.home_goals > game.away_goals
        #wins[team_id] += 1
        #commented out because adding up all of team_id's wins moves it to the top of the list. Not what we want.
      elsif team_id == game.home_team_id && game.home_goals < game.away_goals
        wins[game.away_team_id] += 1
      elsif team_id == game.away_team_id && game.home_goals < game.away_goals
        #wins[team_id] += 1
      elsif team_id == game.away_team_id && game.home_goals > game.away_goals
        wins[game.home_team_id] += 1
      end
    end
    win_percentage = games_played.merge(wins) do |opponent_id, num_of_games, num_won|
      num_won / num_of_games.to_f
    end
    highest_percentage = win_percentage.max_by do |id, percentage|
      percentage
    end
    team = @teams.find do |team|
      highest_percentage.first == team.team_id
    end
    team.team_name
  end

  def average_win_percentage(team_id)
  #Average win percentage of all games for a team.
    relevant_games = @games.find_all do |game|
      game.home_team_id == team_id || game.away_team_id == team_id
    end
    wins = Hash.new(0)
    relevant_games.map do |game|
      if team_id == game.home_team_id && game.home_goals > game.away_goals
        wins[team_id] += 1
      elsif team_id == game.away_team_id && game.home_goals < game.away_goals
        wins[team_id] += 1
      end
    end
    win_percentage = wins[team_id].to_f / relevant_games.length
    win_percentage.round(2)
  end

end
