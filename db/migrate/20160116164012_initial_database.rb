class InitialDatabase < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name

      t.timestamps
    end

    create_table :teams do |t|
      t.string :name

      t.timestamps
    end

    create_table :users do |t|
      t.string :email
      t.text   :auth_meta_data

      t.timestamps
    end

    create_table :ownerships do |t|
      t.integer :user_id
      t.integer :team_id

      t.timestamps
    end

    create_table :memberships do |t|
      t.integer :player_id
      t.integer :team_id

      t.timestamps
    end
  end
end
