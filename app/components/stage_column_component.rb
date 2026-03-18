class StageColumnComponent < ViewComponent::Base
  attr_reader :stage, :deals

  STAGE_COLORS = {
    "lead" => "blue",
    "qualified" => "indigo",
    "proposal" => "purple",
    "negotiation" => "yellow",
    "won" => "green",
    "lost" => "red"
  }.freeze

  def initialize(stage:, deals:)
    @stage = stage
    @deals = deals
  end

  def color
    STAGE_COLORS.fetch(stage, "gray")
  end

  def total_value
    sum = deals.sum(&:value).to_i
    "$#{sum.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
  end
end
