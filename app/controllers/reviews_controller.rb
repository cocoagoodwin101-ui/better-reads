class ReviewsController < ApplicationController
  def index
    @reviews = case params[:sort]
              when "votes"
                Review.left_joins(:votes).group(:id).order(Arel.sql("COALESCE(SUM(votes.value), 0) DESC")).limit(20)
              else
                Review.order(created_at: :desc).limit(20)
              end
  end

  def new
    @books = Book.all.limit(20)
    @review = Review.new
  end

  def create
    @review = Review.new(book_id: params[:review][:book_id].to_i, rating: params[:review][:rating].to_i, content: params[:review][:content], title: params[:review][:title])
    @review.user = current_user

    if @review.save
      redirect_to reviews_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.user = current_user

    if @review.destroy
      redirect_to reviews_url, notice: "Review was successfully destroyed."
    else
      redirect_to reviews_url, alert: "Failed to delete review."
    end
  end

  before_action :set_review, only: [:edit, :update]
  before_action :check_owner, only: [:edit, :update]

  def edit
  end

  def update
    review_params = params.require(:review).permit(:rating, :content, :title)
    if @review.update(review_params)
    redirect_to reviews_url, notice: "Review was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def check_owner
    unless @review.user == current_user
      redirect_to reviews_path, alert: "You are not authorised to edit this review."
    end
  end
end
