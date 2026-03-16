class Company < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :deals, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy

  validates :name, presence: true

  after_update :log_changes

  def display_name
    name
  end

  private

  def log_changes
    saved_changes.except("updated_at").each do |field, (old_val, new_val)|
      activities.create!(
        action: "updated",
        description: "Changed #{field.humanize.downcase} from \"#{old_val}\" to \"#{new_val}\""
      )
    end
  end
end
