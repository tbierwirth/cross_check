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
    games_won = Hash.new(0)

    @game_team_stats.find_all do |game|
      relevant_game_id.find_all do |id|
         if id == game.game_id
              games_played[game.head_coach] += 1
            elsif id == game.game_id && game.won == "TRUE"
            games_won[game.head_coach] += 1

          end
        end
      end
    win_percentage = games_won.merge(games_played) do |coach, won, played|
      won / played.to_f
    end
    worst_percentage = win_percentage.min_by do |coach, percentage|
      percentage
    end
    worst_percentage.first
  end
end
