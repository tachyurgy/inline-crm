class DashboardController < ApplicationController
  def show
    @recent_activities = Activity.for_feed
    @deals_by_stage = Deal.pipeline.group_by(&:stage)
    @contacts_count = Contact.count
    @companies_count = Company.count
    @deals_count = Deal.active.count
    @pipeline_value = Deal.active.sum(:value)
  end
end
