class AddLeagueConcept < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string  :name
      t.integer :commissioner_id

      t.timestamps
    end

    add_column :teams, :league_id, :integer
  end
end
