module TeamStats

  def best_season(team_id)
    win_pct_by_season(team_id)
    best_season = win_pct_by_season(team_id).max_by {|season, win_pct| win_pct}
    best_season.first
  end

  def worst_season(team_id)
    win_pct_by_season(team_id)
    worst_season = win_pct_by_season(team_id).min_by {|season, win_pct| win_pct}
    worst_season.first
  end

  def win_pct_by_season(team_id)
    count_of_team_games_by_season(team_id)
    wins_by_season(team_id)
    win_pct_season = wins_by_season(team_id).merge(count_of_team_games_by_season(team_id)) do |season, wins, games|
      wins / games.to_f
    end
    win_pct_season
  end
  
  def count_of_team_games_by_season(team_id)
    games_by_season = Hash.new(0)
    games.each do |game|
      if game.away_team_id == team_id || game.home_team_id == team_id
        games_by_season[game.season] += 1
      end
    end
    games_by_season
  end

  def wins_by_season(team_id)
    wins_by_season = Hash.new(0)
    @games.count do |game|
      if game.away_team_id == team_id
        if game.outcome.include?("away win")
          wins_by_season[game.season] += 1
        end
      elsif game.home_team_id == team_id
        if game.outcome.include?("home win")
          wins_by_season[game.season] += 1
        end
      end
    end
    wins_by_season
  end

end
