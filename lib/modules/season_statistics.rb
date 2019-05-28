module SeasonStatistics

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
