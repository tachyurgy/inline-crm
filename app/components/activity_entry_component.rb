class ActivityEntryComponent < ViewComponent::Base
  attr_reader :activity

  def initialize(activity:)
    @activity = activity
  end

  def icon_class
    case activity.action
    when "created" then "text-green-500"
    when "updated" then "text-blue-500"
    when "called" then "text-purple-500"
    when "emailed" then "text-yellow-500"
    else "text-gray-500"
    end
  end

  def time_ago
    time_ago_in_words(activity.created_at) + " ago"
  end

  def trackable_name
    activity.trackable&.display_name || "Unknown"
  end

  def trackable_type
    activity.trackable_type&.downcase
  end
end
