class RemoveUpvotesCountFromBooks < ActiveRecord::Migration[7.1]
  def change
    remove_column :books, :upvotes_count, :integer
  end
end
