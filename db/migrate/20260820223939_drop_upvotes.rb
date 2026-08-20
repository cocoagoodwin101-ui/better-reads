class DropUpvotes < ActiveRecord::Migration[7.1]
  def up
    drop_table :upvotes
  end

  def down
    create_table :upvotes do |t|
      t.integer "user_id", null: false
      t.integer "book_id", null: false
      t.timestamps
    end
    add_index :upvotes, :user_id
    add_index :upvotes, :book_id
    add_index :upvotes, [:user_id, :book_id], unique: true, name: "index_upvotes_on_user_id_and_book_id"
  end
end