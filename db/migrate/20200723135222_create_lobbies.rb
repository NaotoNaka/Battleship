class CreateLobbies < ActiveRecord::Migration[5.1]
  def change
    create_table :lobbies do |t|
      t.string :loginname
      t.datetime :applytime

      t.timestamps
    end
  end
end
