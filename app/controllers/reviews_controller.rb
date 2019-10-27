class ReviewsController < ApplicationController

  def new
    @review = Review.new( review_params )
  end

  def create
  end

  def edit
  end

  def update
  end

end
