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

  def head_to_head(id)
    wins = Hash.new(0)
    games = Hash.new(0)
    @games.each do |game|
      if game.away_team_id == id
        games[game.home_team_id] += 1
        if game.outcome.include?("away win")
          wins[game.home_team_id] += 1
        end
      elsif game.home_team_id == id
        games[game.away_team_id] += 1
        if game.outcome.include?("home win")
          wins[game.away_team_id] += 1
        end
      end
    end
    percentages = games.merge(wins) do |team_id, games, wins|
      (wins / games.to_f).round(2)
    end
    result = {}
    percentages.each_pair do |team_id, percentage|
      result[name(team_id)] = percentage
    end
    result
  end

  def name(id)
    team = @teams.find do |team|
      id == team.team_id
    end
    team.team_name
  end

end
