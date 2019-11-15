class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.string :category
      t.text :description
      t.datetime :schedule
      t.integer :user_id
      t.timestamps
    end
  end
end
