class TeamStatHelper

  def initialize(game, team, game_team)
    @game ||= game
    @team ||= team
    @game_team ||= game_team
  end

  def collect_seasons(team_id)
    season_game_id_hash = {}
      @game.each do |game_id, game|
        if  season_game_id_hash[game.season].nil? && (team_id.to_i == game.away_team_id || team_id.to_i == game.home_team_id)
           season_game_id_hash[game.season] = [game]
         elsif (team_id.to_i == game.away_team_id) || (team_id.to_i == game.home_team_id)
           season_game_id_hash[game.season] << game
        end
      end
     season_game_id_hash
  end

  def collect_wins_per_season(team_id)
    season_wins = {}
    collect_seasons(team_id).each do |season, info|
      season_wins[season] = add_game_wins_to_win_count(team_id, info)
    end
    season_wins
  end

  def add_game_wins_to_win_count(team_id, info)
    wins = 0
    info.each do |game|
      if (team_id.to_i) == game.away_team_id && (game.away_goals > game.home_goals)
        wins += 1
      elsif (team_id.to_i) == game.home_team_id && (game.away_goals < game.home_goals)
        wins += 1
      end
    end
    wins
  end

  def collect_losses_per_season(team_id)
    season_losses = {}
    collect_seasons(team_id).each do |season, info|
      season_losses[season] = add_game_losses_to_loss_count(team_id, info)
    end
    season_losses
  end

  def add_game_losses_to_loss_count(team_id, info)
    losses = 0
    info.each do |game|
      if (team_id.to_i) == game.away_team_id && (game.away_goals < game.home_goals || game.away_goals == game.home_goals)
        losses += 1
      elsif (team_id.to_i) == game.home_team_id && (game.away_goals > game.home_goals || game.away_goals == game.home_goals)
        losses += 1
      end
    end
    losses
  end

  def games_for_team_id(team_id)
    games = []
      @game.each do |game_id, game_info|
        if game_info.away_team_id == team_id.to_i || game_info.home_team_id == team_id.to_i
          games << game_info.game_id
        end
      end
     found_games = @game_team.find_all do |game|
      games.include?(game.game_id)
    end
    found_games
  end

  def win_percentages_by_team(opponents, game_count)
    win_percentages = {}
    opponents.each do |team, wins|
      win_percentages[team] = wins / game_count[team].to_f
    end
    win_percentages
  end

  def min_percentage_favorite_team_team_name(win_percentages)
    favorite_team_id = win_percentages.key(win_percentages.values.min)
    favorite_team = @team.find do |team_id, info|
      team_id.to_i == favorite_team_id
    end
    favorite_team[1].team_name
  end

  def max_percentage_favorite_team_team_name(win_percentages)
    favorite_team_id = win_percentages.key(win_percentages.values.max)
    favorite_team = @team.find do |team_id, info|
      team_id.to_i == favorite_team_id
    end
    favorite_team[1].team_name
  end

end
