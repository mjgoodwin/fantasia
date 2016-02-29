class AddRoundsToLeagues < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :league_id
      t.datetime :start_time
      t.string :name
      t.integer :number

      t.timestamps
    end

    add_column :memberships, :round_id, :integer
  end
end
