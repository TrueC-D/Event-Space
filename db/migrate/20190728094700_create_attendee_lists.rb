class CreateAttendeeLists < ActiveRecord::Migration[5.2]
  def change
    create_table :attendee_lists do |t|
      t.integer :user_id
      t.integer :event_id
      t.timestamps null: false
    end
  end
end
