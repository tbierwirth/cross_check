require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/team_info'
require 'pry'

class TeamInfoTest < MiniTest::Test

  def test_it_exists
    team = {"team_id": "1", "franchiseId": "23", "shortName": "New Jersey", "teamName": "Devils", "abbreviation": "NJD", "link": "/api/v1/teams/1"}
    team_info = TeamInfo.new(team)

    assert_instance_of TeamInfo, team_info
  end
end
