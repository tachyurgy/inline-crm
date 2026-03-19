class ContactsController < ApplicationController
  before_action :set_contact, only: %i[show update destroy]

  def index
    @contacts = Contact.includes(:company).order(:first_name)
  end

  def show
    @activities = @contact.activities.recent.limit(20)
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      @contact.activities.create!(action: "created", description: "Contact was created")
      redirect_to @contact, notice: "Contact created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @contact.update(contact_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@contact, contact_params.keys.first),
            EditableFieldComponent.new(
              record: @contact,
              field: contact_params.keys.first.to_sym,
              input_type: field_type(contact_params.keys.first)
            )
          )
        end
        format.html { redirect_to @contact }
      end
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path, notice: "Contact deleted."
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :phone, :title, :company_id, :notes)
  end

  def field_type(field)
    case field
    when "notes" then :textarea
    else :text
    end
  end
end
