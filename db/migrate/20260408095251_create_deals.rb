class CreateDeals < ActiveRecord::Migration[8.1]
  def change
    create_table :deals do |t|
      t.string :name
      t.string :stage
      t.decimal :value, precision: 12, scale: 2
      t.references :company, null: false, foreign_key: true
      t.references :contact, foreign_key: true
      t.text :notes
      t.integer :position

      t.timestamps
    end
  end
end
