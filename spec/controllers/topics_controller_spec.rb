require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe TopicsController do
  def valid_attributes
    { :name => 'Foo',
      :url => 'http://foo.local/' }
  end

  def create_site
    @site ||= FactoryGirl.create(:site1, :user => kotori)
  end

  def create_topic
    @topic ||= FactoryGirl.create(:topic, :site => create_site) 
  end

  describe "GET show" do
    def visit_normally
      get :show, :id => create_topic.id.to_s
    end

    include_examples "doesn't require authentication"
    include_examples "returns a successful response"
  end
end

describe TopicsController do
  render_views

  before :each do
    sign_in(admin)
  end

  def valid_attributes
    { :name => 'Foo',
      :url => 'http://foo.local/' }
  end

  def create_site
    @site ||= FactoryGirl.create(:site1, :user => admin)
  end
  
  def create_topic
    @topic ||= FactoryGirl.create(:topic, :site => create_site)
  end

  describe "GET show" do
    before :each do
      create_topic
    end

    def visit_normally
      get :show, :id => @topic.id.to_s
    end

    it "assigns the requested topic as @topic" do
      visit_normally
      assigns(:topic).should eq(@topic)
    end
  end
end
