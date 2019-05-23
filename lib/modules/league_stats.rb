module LeagueStats

  def lowest_scoring_home_team
    home_goals_by_team = Hash.new(0)
    home_games_by_team = Hash.new(0)

    @game_team_stats.each do |game|
      if game.hoa == "home"
        home_goals_by_team[game.team_id] += game.goals.to_i
        home_games_by_team[game.team_id] += 1
      end
    end
    home_games_by_team.each do |team, games|
      home_goals_by_team[team] = (home_goals_by_team[team] / games.to_f).round(2)
    end
    lowest_scoring_team = home_goals_by_team.min_by {|team, avg_goals| avg_goals}
    lowest_home_team = @teams.find do |team|
      if team.team_id == lowest_scoring_team[0]
        team.team_name
      end
    end
    lowest_home_team.team_name
  end

end
