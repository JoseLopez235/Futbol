module SeasonStatistics

  def find_all_seasons
    seasons = []
    @game_table.each do |game_id, game|
      if !seasons.include?(game.season)
        seasons << game.season
      end
    end
    seasons
  end

  def coaches_per_season(seasons)
    coaches_per_season = {}
    game_table = @game_table
    seasons.each do |season|
      @game_team_table.each do |game|
        if game_table[(game.game_id).to_s].season == season
          if coaches_per_season[season].nil?
            coaches_per_season[season] = {game.head_coach => [game.result]}
          elsif coaches_per_season[season][game.head_coach]
            coaches_per_season[season][game.head_coach] << game.result
          else
            coaches_per_season[season][game.head_coach] = [game.result]
          end
        end
      end
    end
    coaches_per_season
  end

  def winningest_coach(season)
    season_coach_hash = coaches_per_season(find_all_seasons)
    winningest_coach_name = nil
    highest_percentage = 0
    season_coach_hash[season].each do |key, value|
      total_games = 0
      total_wins = 0
      total_losses = 0
      total_ties = 0
      value.each do |game_result|
        total_games += 1
        if game_result == "WIN"
          total_wins += 1
        elsif game_result == "LOSS"
          total_losses += 1
        elsif game_result == "TIE"
          total_ties += 1
        end
      end
      if (total_wins.to_f / total_games) > highest_percentage && total_games > 5
        highest_percentage = (total_wins.to_f ) / total_games
        winningest_coach_name = key
      end
    end
    winningest_coach_name
  end

  def worst_coach(season)
    season_coach_hash = coaches_per_season(find_all_seasons)
    worst_coach_name = nil
    lowest_percentage = 1
    season_coach_hash[season].each do |key, value|
      total_games = 0
      total_wins = 0
      total_losses = 0
      total_ties = 0
      value.each do |game_result|
        total_games += 1
        if game_result == "WIN"
          total_wins += 1
        elsif game_result == "LOSS"
          total_losses += 1
        elsif game_result == "TIE"
          total_ties += 1
        end
      end
      if (total_wins.to_f / total_games) <= lowest_percentage
        lowest_percentage = (total_wins.to_f / total_games)
        worst_coach_name = key
      end
    end
    worst_coach_name
  end

  def season_games(season)
    games = []
    @game_table.each do |game_id, game|
      games << game if season == game.season
    end
    games
  end

  def team_tackles_by_season(games)
    tackles = {}
    games.each do |game|
      game_teams_array = @game_team_table.find_all do |game_info|
        game.game_id == game_info.game_id
      end
      game_teams_array.each do |team|
        if tackles[team.team_id].nil?
          tackles[team.team_id] = team.tackles
        else
          tackles[team.team_id] += team.tackles
        end
      end
    end
    tackles
  end

  def most_tackles(season)
    season_games = season_games(season)
    team_tackles = team_tackles_by_season(season_games)
    team_id = team_tackles.key(team_tackles.values.max)
    @team_table[team_id.to_s].team_name
  end

end
