require "test_helper"

class VotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
    @review = reviews(:one)
    @user = users(:austin)
    post session_path, params: { email: @user.email, password: "betterreads" }
  end

  test "should create an upvote on a book" do
    assert_difference("Vote.count", 1) do
      post book_votes_path(@book), params: { value: 1 }
    end

    vote = Vote.last
    assert_equal 1, vote.value
    assert_equal @book, vote.votable
    assert_redirected_to root_path
    assert_equal "Vote recorded.", flash[:notice]
  end

  test "should create a downvote on a book" do
    assert_difference("Vote.count", 1) do
      post book_votes_path(@book), params: { value: -1 }
    end

    vote = Vote.last
    assert_equal(-1, vote.value)
    assert_equal @book, vote.votable
  end

  test "clicking the same direction again removes the vote" do
    post book_votes_path(@book), params: { value: 1 } # first upvote

    assert_difference("Vote.count", -1) do
      post book_votes_path(@book), params: { value: 1 } # same direction again
    end

    assert_equal "Vote removed.", flash[:notice]
  end

  test "clicking the opposite direction switches the vote" do
    post book_votes_path(@book), params: { value: 1 } # upvote first
    vote = Vote.last

    assert_no_difference("Vote.count") do
      post book_votes_path(@book), params: { value: -1 } # switch to downvote
    end

    assert_equal(-1, vote.reload.value)
    assert_equal "Vote updated.", flash[:notice]
  end

  test "should create an upvote on a review" do
    assert_difference("Vote.count", 1) do
      post review_votes_path(@review), params: { value: 1 }
    end

    vote = Vote.last
    assert_equal 1, vote.value
    assert_equal @review, vote.votable
  end

  test "different users can each vote on the same book" do
    post book_votes_path(@book), params: { value: 1 } # austin votes

    post session_path, params: { email: users(:bri).email, password: "betterreads" }

    assert_difference("Vote.count", 1) do
      post book_votes_path(@book), params: { value: 1 } # brianna votes
    end
  end
end