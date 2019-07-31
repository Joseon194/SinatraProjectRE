class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.integer :user_id
      t.string :name
      t.string :color
      t.string :company
      t.string :model_year
  end
end
end
