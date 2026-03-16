class Contact < ApplicationRecord
  belongs_to :company, optional: true
  has_many :deals, dependent: :nullify
  has_many :activities, as: :trackable, dependent: :destroy

  validates :first_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  after_update :log_changes

  def full_name
    [first_name, last_name].compact_blank.join(" ")
  end

  def display_name
    full_name
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
