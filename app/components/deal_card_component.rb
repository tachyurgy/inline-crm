class DealCardComponent < ViewComponent::Base
  attr_reader :deal

  def initialize(deal:)
    @deal = deal
  end
end
