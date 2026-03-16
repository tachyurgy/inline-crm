class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.string :action
      t.text :description
      t.references :trackable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
