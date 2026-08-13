require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "review model validates presence of required fields" do
    review = Review.new
    assert_not review.save
    assert_equal [:book, :user, :rating, :content], review.errors.as_json.keys
  end
end
