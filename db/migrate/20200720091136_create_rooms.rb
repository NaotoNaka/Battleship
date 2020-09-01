class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :loginname
      t.string :opponent
      t.string :myfield
      t.string :hits

      t.timestamps
    end
  end
end
