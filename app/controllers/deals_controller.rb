class DealsController < ApplicationController
  before_action :set_deal, only: %i[show update destroy move]

  def index
    @deals_by_stage = Deal::STAGES.each_with_object({}) do |stage, hash|
      hash[stage] = Deal.in_stage(stage).includes(:company, :contact).order(:position)
    end
  end

  def show
    @activities = @deal.activities.recent.limit(20)
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(deal_params)
    if @deal.save
      @deal.activities.create!(action: "created", description: "Deal was created")
      redirect_to deals_path, notice: "Deal created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @deal.update(deal_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@deal, deal_params.keys.first),
            EditableFieldComponent.new(
              record: @deal,
              field: deal_params.keys.first.to_sym,
              input_type: field_type(deal_params.keys.first)
            )
          )
        end
        format.html { redirect_to @deal }
      end
    else
      head :unprocessable_entity
    end
  end

  def move
    old_stage = @deal.stage
    new_stage = params.dig(:deal, :stage)

    if new_stage && Deal::STAGES.include?(new_stage) && @deal.update(stage: new_stage)
      render turbo_stream: [
        turbo_stream.replace("stage-#{old_stage}", StageColumnComponent.new(
          stage: old_stage,
          deals: Deal.in_stage(old_stage).includes(:company, :contact).order(:position)
        )),
        turbo_stream.replace("stage-#{new_stage}", StageColumnComponent.new(
          stage: new_stage,
          deals: Deal.in_stage(new_stage).includes(:company, :contact).order(:position)
        ))
      ]
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @deal.destroy
    redirect_to deals_path, notice: "Deal deleted."
  end

  private

  def set_deal
    @deal = Deal.find(params[:id])
  end

  def deal_params
    params.require(:deal).permit(:name, :stage, :value, :company_id, :contact_id, :notes)
  end

  def field_type(field)
    case field
    when "notes" then :textarea
    when "value" then :number
    when "stage" then :select
    else :text
    end
  end
end
