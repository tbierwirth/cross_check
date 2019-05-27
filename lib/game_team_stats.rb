class GameTeamStats
  attr_reader :team_id,
              :hoa,
              :game_id,
              :goals,
              :won,
              :shots

  def initialize(row)
    @game_id = row["game_id"]
    @team_id = row["team_id"]
    @hoa = row["HoA"]
    @won = row["won"]
    @settled_in = row["settled_in"]
    @head_coach = row["head_coach"]
    @goals = row["goals"]
    @shots = row["shots"]
    @hits = row["hits"]
    @pim = row["pim"]
    @power_play_opportunities = row["powerPlayOpportunities"]
    @power_play_goals = row["powerPlayGoals"]
    @face_off_win_percentage = row["faceOffWinPercentage"]
    @giveaways = row["giveaways"]
    @takeaways = row["takeaways"]
  end

end
