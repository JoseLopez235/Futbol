class Team
  attr_reader :team_id,
              :franchise_id,
              :team_name,
              :abbreviation,
              :stadium,
              :link
  def initialize(data)
    @team_id = data[:team_id]
    @franchise_id = data[:franchiseId]
    @team_name = data[:team_name]
    @abbreviation = data[:abbreviation]
    @stadium = data[:stadium]
    @link = data[:link]
  end

end
