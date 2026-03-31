class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show update destroy]

  def index
    companies = Company.order(:name)
    if params[:q].present?
      q = "%#{params[:q]}%"
      companies = companies.where("name ILIKE :q OR industry ILIKE :q", q: q)
    end
    @pagy, @companies = pagy(companies)
  end

  def show
    @contacts = @company.contacts.order(:first_name)
    @deals = @company.deals.order(:created_at)
    @activities = @company.activities.recent.limit(20)
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      @company.activities.create!(action: "created", description: "Company was created")
      redirect_to @company, notice: "Company created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      respond_to do |format|
        format.turbo_stream do
          field = company_params.keys.first
          streams = [
            turbo_stream.replace(
              dom_id(@company, field),
              EditableFieldComponent.new(
                record: @company,
                field: field.to_sym,
                input_type: field_type(field)
              )
            )
          ]
          if field == "name"
            streams << turbo_stream.update("page-title", @company.name)
          end
          render turbo_stream: streams
        end
        format.html { redirect_to @company }
      end
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_path, notice: "Company deleted."
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :industry, :website, :phone, :notes)
  end

  def field_type(field)
    case field
    when "notes" then :textarea
    else :text
    end
  end
end
