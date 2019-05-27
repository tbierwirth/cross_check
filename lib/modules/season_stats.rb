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

end
