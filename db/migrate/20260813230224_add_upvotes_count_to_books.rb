class AddUpvotesCountToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :upvotes_count, :integer, default: 0, null: false
  end
end
