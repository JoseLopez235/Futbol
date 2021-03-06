require_relative 'season_stat_helper'
class SeasonStatistics < SeasonStatHelper

  def winningest_coach(season)
    winningest_coach_name = nil
    highest_percentage = 0
    coaches_per_season(find_all_seasons)[season].each do |coach, results|
      total_games = 0
      total_wins = 0
      results.each do |game_result|
        total_games += 1
        total_wins += 1 if game_result == "WIN"
      end
      if (total_wins.to_f / total_games) > highest_percentage
        highest_percentage = (total_wins.to_f ) / total_games
        winningest_coach_name = coach
      end
    end
    winningest_coach_name
  end

  def worst_coach(season)
    worst_coach_name = nil
    lowest_percentage = 1
    coaches_per_season(find_all_seasons)[season].each do |key, value|
      total_games = 0
      total_wins = 0
      value.each do |game_result|
        total_games += 1
        total_wins += 1 if game_result == "WIN"
      end
      if (total_wins.to_f / total_games) <= lowest_percentage
        lowest_percentage = (total_wins.to_f / total_games)
        worst_coach_name = key
      end
    end
    worst_coach_name
  end

  def most_accurate_team(season)
    most_accurate_team_for_season = {}
    shots_per_season = collect_shots_per_season(season)
    collect_goals_per_team(season).each do |team, goals|
      most_accurate_team_for_season[team] = (goals / shots_per_season[team].to_f)
    end
    most_accurate_team_for_season.key(most_accurate_team_for_season.values.max)
  end

  def least_accurate_team(season)
    least_accurate_team_for_season = {}
    shots_per_season = collect_shots_per_season(season)
    collect_goals_per_team(season).each do |team, goals|
      least_accurate_team_for_season[team] = (goals / shots_per_season[team].to_f)
    end
    least_accurate_team_for_season.key(least_accurate_team_for_season.values.min)
  end

  def most_tackles(season)
    season_games = collects_season_with_games[season]
    team_tackles = team_tackles_by_season(season_games)
    team_id = team_tackles.key(team_tackles.values.max)
    @team[team_id.to_s].team_name
  end

  def fewest_tackles(season)
    season_games = collects_season_with_games[season]
    team_tackles = team_tackles_by_season(season_games)
    team_id = team_tackles.key(team_tackles.values.min)
    @team[team_id.to_s].team_name
  end

end
