class ChangeCompanyNullOnContacts < ActiveRecord::Migration[8.1]
  def change
    change_column_null :contacts, :company_id, true
  end
end
