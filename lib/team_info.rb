class TeamInfo
  attr_reader :team_id, :team_name

  def initialize(row)
    @team_id = row["team_id"]
    @franchise_id = row["franchiseId"]
    @short_name = row["shortName"]
    @team_name = row["teamName"]
    @abbreviation = row["abbreviation"]
    @link = row["link"]
  end
end
