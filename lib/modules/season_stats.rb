require 'pry'
module SeasonStats

  def get_game_ids(season_id)
    game_ids = []
    @games.each do |game|
      if game.season == season_id
        game_ids << game.game_id
      end
    end
    game_ids
  end

  def most_accurate_team(season_id)
    team_shots = Hash.new(0)
    team_goals = Hash.new(0)
    game_ids = get_game_ids(season_id)
    @game_team_stats.each do |game|
      game_ids.each do |id|
        if game.game_id == id
          team_shots[name(game.team_id)] += game.shots.to_i
          team_goals[name(game.team_id)] += game.goals.to_i
        end
      end
    end
    accuracy = team_goals.merge(team_shots) do |name, goals, shots|
      goals.to_f / shots.to_f
    end
    (accuracy.max_by{|name, accuracy| accuracy})[0]
  end

  def least_accurate_team(season_id)
    team_shots = Hash.new(0)
    team_goals = Hash.new(0)
    game_ids = get_game_ids(season_id)
    @game_team_stats.each do |game|
      game_ids.each do |id|
        if game.game_id == id
          team_shots[name(game.team_id)] += game.shots.to_i
          team_goals[name(game.team_id)] += game.goals.to_i
        end
      end
    end
    accuracy = team_goals.merge(team_shots) do |name, goals, shots|
      goals.to_f / shots.to_f
    end
    (accuracy.min_by{|name, accuracy| accuracy})[0]
  end

  def power_play_goal_percentage(season_id)
    game_ids = get_game_ids(season_id)
    goals = 0
    power_play_goals = 0
    @game_team_stats.each do |game|
      game_ids.each do |id|
        if game.game_id == id
          goals += game.goals.to_i
          power_play_goals += game.power_play_goals.to_i
        end
      end
    end
    (power_play_goals / goals.to_f).round(2)
  end

  def most_hits(season_id)
    game_ids = get_game_ids(season_id)
    teams = Hash.new(0)
    @game_team_stats.each do |game|
      game_ids.each do |id|
        if game.game_id == id
          teams[name(game.team_id)] += game.hits.to_i
        end
      end
    end
    (teams.max_by{|name, hits| hits})[0]
  end

  def fewest_hits(season_id)
    game_ids = get_game_ids(season_id)
    teams = Hash.new(0)
    @game_team_stats.each do |game|
      game_ids.each do |id|
        if game.game_id == id
          teams[name(game.team_id)] += game.hits.to_i
        end
      end
    end
    (teams.min_by{|name, hits| hits})[0]
  end

  def worst_coach(season)
#Name of the Coach with the worst win percentage for the season
    relevant_game_id = []
    @games.each do |game|
      if season == game.season
        relevant_game_id << game.game_id
      end
    end
    games_played = Hash.new(0)
    games_lost = Hash.new(0)

    @game_team_stats.find_all do |game|
      relevant_game_id.find_all do |id|
         if id == game.game_id
              games_played[game.head_coach] += 1
            if id == game.game_id && game.won == "FALSE"
            games_lost[game.head_coach] += 1
            end
          end
        end
      end
    win_percentage = games_lost.merge(games_played) do |coach, lost, played|
      1 - (lost / played.to_f)
    end
    worst_percentage = win_percentage.min_by do |coach, percentage|
      percentage
    end
    worst_percentage.first
  end

  def winningest_coach(season)
    #Name of the Coach with the best win percentage for the season.
    relevant_game_id = []
    @games.each do |game|
      if season == game.season
        relevant_game_id << game.game_id
      end
    end
    games_played = Hash.new(0)
    games_lost = Hash.new(0)

    @game_team_stats.find_all do |game|
      relevant_game_id.find_all do |id|
         if id == game.game_id
              games_played[game.head_coach] += 1
            if id == game.game_id && game.won == "FALSE"
            games_lost[game.head_coach] += 1
            end
          end
        end
      end
    win_percentage = games_lost.merge(games_played) do |coach, lost, played|
      1 - (lost / played.to_f)
    end
    best_percentage = win_percentage.max_by do |coach, percentage|
      percentage
    end
    best_percentage.first
  end

end
