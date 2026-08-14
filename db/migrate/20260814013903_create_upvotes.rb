class CreateUpvotes < ActiveRecord::Migration[7.1]
  def change
    create_table :upvotes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
    add_index :upvotes, [:user_id, :book_id], unique: true
  end
end
