class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.datetime :start, null: false
      t.datetime :finish, null: false
      t.integer :break_length, null: false
      t.integer :user_id, null: false
      t.timestamps precision: 6, null: false
    end
  end
end
