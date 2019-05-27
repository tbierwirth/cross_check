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

  def reg_season_goals_against(team_id)
    reg_season_goals = Hash.new(0)
    @games.each do |game|
      if game.home_team_id == team_id && game.type == "R"
        reg_season_goals[game.season] += game.away_goals.to_i
      elsif game.away_team_id == team_id && game.type == "R"
        reg_season_goals[game.season] += game.home_goals.to_i
      end
    end
    reg_season_goals
  end

  def post_season_goals_against(team_id)
    post_season_goals = Hash.new(0)
    @games.each do |game|
      if game.home_team_id == team_id && game.type == "P"
        post_season_goals[game.season] += game.away_goals.to_i
      elsif game.away_team_id == team_id && game.type == "P"
        post_season_goals[game.season] += game.home_goals.to_i
      end
    end
    post_season_goals
  end

  def reg_season_games(team_id)
    reg_games_by_season = Hash.new(0)
    games.each do |game|
      if (game.away_team_id == team_id || game.home_team_id == team_id) && game.type == "R"
        reg_games_by_season[game.season] += 1
      end
    end
    reg_games_by_season
  end

  def post_season_games(team_id)
    post_games_by_season = Hash.new(0)
    games.each do |game|
      if (game.away_team_id == team_id || game.home_team_id == team_id) && game.type == "P"
        post_games_by_season[game.season] += 1
      end
    end
    post_games_by_season
  end

end
