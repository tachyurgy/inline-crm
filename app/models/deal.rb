class Deal < ApplicationRecord
  STAGES = %w[lead qualified proposal negotiation won lost].freeze

  belongs_to :company
  belongs_to :contact, optional: true
  has_many :activities, as: :trackable, dependent: :destroy

  validates :name, presence: true
  validates :stage, inclusion: { in: STAGES }
  validates :value, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_validation :set_defaults
  after_update :log_changes

  scope :in_stage, ->(stage) { where(stage: stage) }
  scope :pipeline, -> { where.not(stage: %w[won lost]).order(:position) }
  scope :active, -> { where.not(stage: %w[won lost]) }

  def display_name
    name
  end

  def formatted_value
    return "N/A" unless value
    "$#{value.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
  end

  private

  def set_defaults
    self.stage ||= "lead"
    self.position ||= (Deal.where(stage: stage).maximum(:position) || 0) + 1
  end

  def log_changes
    saved_changes.except("updated_at", "position").each do |field, (old_val, new_val)|
      desc = if field == "stage"
        "Moved from #{old_val.humanize} to #{new_val.humanize}"
      else
        "Changed #{field.humanize.downcase} from \"#{old_val}\" to \"#{new_val}\""
      end
      activities.create!(action: "updated", description: desc)
    end
  end
end
