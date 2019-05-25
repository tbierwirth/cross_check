module TeamStats

  def team_info(team_id)
    #team_info returns key value pairs for each of the attributes of the team passed to it.

    target_team = @teams.find do |team|
      team.team_id == team_id
    end

    target_team.instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete('@')] = target_team.instance_variable_get(var)

    end
  end
end
