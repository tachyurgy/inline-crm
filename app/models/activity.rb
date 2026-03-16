class Activity < ApplicationRecord
  belongs_to :trackable, polymorphic: true

  validates :action, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :for_feed, -> { recent.limit(50).includes(:trackable) }
end
