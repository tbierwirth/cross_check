class GameTeamStats

  def initialize(row)
    @game_id = row["game_id"]
    @team_id = row["team_id"]
    @HoA = row["HoA"]
    @won = row["won"]
    @settled_in = row["settled_in"]
    @head_coach = row["head_coach"]
    @goals = row["goals"]
    @shots = row["shots"]
    @hits = row["hits"]
    @pim = row["pim"]
    @powerPlayOpportunities = row["powerPlayOpportunities"]
    @powerPlayGoals = row["powerPlayGoals"]
    @faceOffWinPercentage = row["faceOffWinPercentage"]
    @giveaways = row["giveaways"]
    @takeaways = row["takeaways"]
  end

end
