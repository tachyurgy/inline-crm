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
      if params[:quick_add]
        head :ok
      else
        redirect_to deals_path, notice: "Deal created."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @deal.update(deal_params)
      respond_to do |format|
        format.turbo_stream do
          field = deal_params.keys.first
          streams = [
            turbo_stream.replace(
              dom_id(@deal, field),
              EditableFieldComponent.new(
                record: @deal,
                field: field.to_sym,
                input_type: field_type(field)
              )
            )
          ]
          if field == "name"
            streams << turbo_stream.update("page-title", @deal.name)
          end
          render turbo_stream: streams
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
    new_position = params.dig(:deal, :position)&.to_i

    return head(:unprocessable_entity) unless new_stage && Deal::STAGES.include?(new_stage)

    @deal.update!(stage: new_stage)

    # Reorder within the target stage
    if new_position
      deals_in_stage = Deal.in_stage(new_stage).where.not(id: @deal.id).order(:position).to_a
      deals_in_stage.insert(new_position, @deal)
      deals_in_stage.each_with_index do |deal, idx|
        deal.update_column(:position, idx)
      end
    end

    stages_to_refresh = [new_stage]
    stages_to_refresh << old_stage if old_stage != new_stage

    render turbo_stream: stages_to_refresh.map { |stage|
      turbo_stream.replace("stage-#{stage}", StageColumnComponent.new(
        stage: stage,
        deals: Deal.in_stage(stage).includes(:company, :contact).order(:position)
      ))
    }
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
