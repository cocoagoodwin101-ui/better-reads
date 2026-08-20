class VotesController < ApplicationController
  def create
    votable_type = params[:votable_type]
    votable_id = params[:book_id] || params[:review_id]
    votable = votable_type.constantize.find(votable_id)
    new_value = params[:value].to_i

    existing_vote = Vote.find_by(user: current_user, votable: votable)

    if existing_vote.nil?
        Vote.create!(user: current_user, votable: votable, value: new_value)
        flash[:notice] = "Vote recorded."
    elsif existing_vote.value == new_value
        existing_vote.destroy
        flash[:notice] = "Vote removed."
    else
        existing_vote.update!(value: new_value)
        flash[:notice] = "Vote updated."
    end

    redirect_back(fallback_location: root_path)
    end
end