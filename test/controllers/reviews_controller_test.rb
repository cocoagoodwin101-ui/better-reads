require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest

  setup do
    user = users(:austin)
    post session_path, params: { email: user.email, password: "betterreads" }
  end

  test "should get index" do
    get reviews_path
    assert_response :success
  end

  test "should create a review" do
    book = books(:one)
    assert_difference("Review.count", 1) do
      post reviews_path, params: { review: { book_id: book.id, rating: 5, content: "Great book!", title: "Great book!" } }
    end
  end

  test "should order reviews by created_at descending" do
    book = books(:one)
    older = Review.create!(book: book, user: users(:austin), rating: 5, title: "Same Title", content: "MARKER_OLD_#{SecureRandom.hex(4)}", created_at: 2.days.ago)
    newer = Review.create!(book: book, user: users(:austin), rating: 5, title: "Same Title", content: "MARKER_NEW_#{SecureRandom.hex(4)}", created_at: 1.hour.ago)

    get reviews_path
    assert_response :success

    assert response.body.index(newer.content) < response.body.index(older.content)
  end

  test "should sort reviews by votes descending" do
    review_a = reviews(:one)
    review_b = Review.create!(book: books(:one), user: users(:bri), title: "Second review", content: "Content here", rating: 3)

    Vote.create!(user: users(:austin), votable: review_a, value: 1)
    Vote.create!(user: users(:bri), votable: review_a, value: 1)
    Vote.create!(user: users(:austin), votable: review_b, value: 1)

    get reviews_path(sort: "votes")
    assert_response :success

    positions = [review_a, review_b].map { |r| response.body.index(r.title) }
    assert_equal positions, positions.sort
  end

end
