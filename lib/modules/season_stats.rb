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

end
