require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
    @user = users(:austin)
    post session_path, params: { email: @user.email, password: "betterreads" }
  end

  test "should get index" do
    get books_url
    assert_response :success
  end

  test "should get new" do
    get new_book_url
    assert_response :success
  end

  test "should create book" do
    assert_difference("Book.count") do
      post books_url, params: { book: { author_id: @book.author_id, description: @book.description, title: @book.title } }
    end

    assert_redirected_to book_url(Book.last)
  end

  test "should show book" do
    get book_url(@book)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_url(@book)
    assert_response :success
  end

  test "should update book" do
    patch book_url(@book), params: { book: { author_id: @book.author_id, description: @book.description, title: @book.title } }
    assert_redirected_to book_url(@book)
  end

  test "should destroy book" do
    assert_difference("Book.count", -1) do
      delete book_url(@book)
    end

    assert_redirected_to books_url
  end

  test "should sort books by votes descending" do
    book_a = books(:one)
    book_b = books(:two)

    Vote.create!(user: users(:austin), votable: book_a, value: 1)
    Vote.create!(user: users(:bri), votable: book_a, value: 1)
    Vote.create!(user: users(:austin), votable: book_b, value: 1)

    get books_path(sort: "votes")
    assert_response :success

    positions = [book_a, book_b].map { |b| response.body.index(b.title) }
    assert_equal positions, positions.sort
  end

end
