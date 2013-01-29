class TopicsController < ApplicationController
  def index
    @topics = Topic.visible.all
  end
  def show
  end
end
