class ActivitiesController < ApplicationController
  def index
    @activities = Activity.for_feed
  end

  def create
    trackable = find_trackable
    @activity = trackable.activities.new(
      action: params[:activity][:action] || "noted",
      description: params[:activity][:description]
    )

    if @activity.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend(
            "activity-feed",
            ActivityEntryComponent.new(activity: @activity)
          )
        end
        format.html { redirect_back fallback_location: root_path }
      end
    else
      head :unprocessable_entity
    end
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

  private

  def find_trackable
    if params[:contact_id]
      Contact.find(params[:contact_id])
    elsif params[:company_id]
      Company.find(params[:company_id])
    elsif params[:deal_id]
      Deal.find(params[:deal_id])
    end
  end
end
