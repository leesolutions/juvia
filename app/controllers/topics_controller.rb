class TopicsController < ApplicationController
  load_and_authorize_resource
  def show
    render :show, :layouts => :topics
  end
end
