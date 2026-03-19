class ActivitiesController < ApplicationController
  def index
    @activities = Activity.for_feed
  end

  def feed
    last_id = params[:since].to_i
    @activities = Activity.where("id > ?", last_id).recent.limit(10).includes(:trackable)

    if @activities.any?
      render turbo_stream: @activities.map { |activity|
        turbo_stream.prepend("activity-feed", ActivityEntryComponent.new(activity: activity))
      }
    else
      head :no_content
    end
  end
end
