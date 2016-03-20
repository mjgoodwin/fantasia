class AddGamesAndStatLines < ActiveRecord::Migration
  def change
    create_table :sports do |t|
      t.string :name
    end

    create_table :games do |t|
      t.integer :sport_id
      t.datetime :start_time
      t.string :description
    end

    create_table :golfstatlines do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :score
    end

    create_table :games_rounds do |t|
      t.integer :game_id
      t.integer :round_id
    end

    add_column :leagues, :sport_id, :integer
  end
end
