class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :mark
      t.belongs_to :votable
      t.string :votable_type
      t.belongs_to :user
      t.timestamps
    end
  end
end
