require 'test_helper'
class ArticlesControllerTest < ActionController::TestCase
  def setup
      @article = Factory.create(:article_ruby)
      Factory.create(:article_rails)
      Factory.create(:article_sinatra)
  end

  def teardown
    Article.all.each { |article| article.destroy }
  end

  context "user" do 

    should "view list of articles" do
      get :index
      assert_response :success
      assert_template "index"
      assert_equal 3, assigns(:articles).size
    end

    should "not see hidden articles" do
      Factory.create(:unpublished_article)
      
      get :index, :show_hidden => true
      assert_response :success
      assert_template "index"
      assert_equal 3, assigns(:articles).size
    end

    should "view articles sorted by last published by default" do
      last_published = Article.order_by(:published_at.desc).first

      get :index, :order => "updated_at"
      assert_response :success
      assert_template "index"
      assert_equal last_published.title, assigns(:articles).first.title
    end

    should "filter articles by tag" do
      get :index, :tag => "ruby"
      assert_response :success
      assert_equal 2, assigns(:articles).size
    end

    should "not get any articles when filtering by non-existent tag" do
      get :index, :tag => "assembler"
      assert_response :success
      assert_equal 0, assigns(:articles).size
    end

    should "filter articles by date range" do
      get :index, :from => '05.02.2011', :to => '09.02.2011'
  
      assert_response :success
      assert_equal 1, assigns(:articles).size
    end

    should "get all articles when filtering by invalid date range" do
      get :index, :from => '08.20.2011', :to => '10.02.2011'
   
      assert_response :success
      assert_equal 3, assigns(:articles).size
      # PS: we won't allow user to enter date range directly
      assert_nil flash.alert
    end

    should "view article by id" do
      get :show, :id => @article.to_param
      assert_response :success
      assert_equal @article.to_param, assigns(:article).to_param
    end

    should "view article by alias (= parameterized name)" do
      get :show, :id => @article.alias
      assert_response :success
      assert_equal @article.to_param, assigns(:article).to_param
    end
  
    should "get 404 error when viewing non-existent article" do    
      assert_raise(ActionController::RoutingError) { get :show, :id => "123" }  
    end

    should "view article by alias including year and month" do
      get :show, :id => @article.alias, :year => @article.published_at.year,
      :month => sprintf("%02d", @article.published_at.month)
    end
    
    should "/articles/YYYY should display all articles for given year" do
      year = @article.published_at.year
      @article.published_at = @article.published_at + 1.year
      @article.save

      get :index, :year => year
      assert_response :success
      assert_equal 2, assigns(:articles).size
    end

    # these tests are brittle and break if :month is in another :year
    # TODO hardcode dates into factories' default values
    #
    should "/articles/YYYY/MM should display all articles for given month" do
      month = sprintf("%02d", @article.published_at.month)
      @article.published_at = @article.published_at + 1.month
      @article.save
      
      get :index, { :year => @article.published_at.year, :month => month }
      assert_response :success
      assert_equal 2, assigns(:articles).size
    end

    should "get 404 error when given invalid year in /articles url" do
      assert_raise(ActionController::RoutingError) { get '/articles/20112' }  
      assert_raise(ActionController::RoutingError) { get '/articles/20112/03'  }  
    end

    should "get 404 error when given invalid month in /articles url" do
      assert_raise(ActionController::RoutingError) { get '/articles/2011/033' }  
    end
  
  end
  
  context "admin user" do

    setup do
      @article_data = {
        :title => "I like blogging",
        :content => "<p>Man, how do I like blogging and sharing my<br />" +
          "thoughts with the world!</p>"
      }

      # FIXME currently hotfixed so tests run without errors, but that doesn't
      # necessarily mean that they work
      @controller.expects(:admin_access_required).times(0..2).returns(true)
      @controller.expects(:admin?).at_least(1).times(0..2).returns(true)
    end

    should "view admin list of articles" do
      get :index
      assert_response :success
      assert_template "admin_index"
      assert_equal 3, assigns(:articles).size
    end

    should "see hidden articles" do
      Factory.create(:unpublished_article)
      
      get :index
      assert_response :success
      assert_template "admin_index"
      assert_equal 4, assigns(:articles).size
    end

    should "view articles sorted by last updates by default" do
      last_updated = Article.order_by(:updated_at.desc).first

      get :index
      assert_response :success
      assert_template "admin_index"
      assert_equal last_updated.title, assigns(:articles).first.title
    end

    should "write new article" do      
      get :new

      assert_response :success
      assert assigns(:article).title.blank?
      assert assigns(:article).content.blank?
    end

    should "not create invalid article" do      
      post :create, :article => { :content => @article_data[:content] }

      assert_response :success
      assert_template :new
      assert_not_nil flash.alert
      assert ! Article.where(:title => @article_data[:title]).first
    end

    should "create valid article" do      
      post :create, :article => @article_data

      new_article = Article.where(:title => @article_data[:title]).first
      assert_redirected_to article_path(new_article.to_param)
      assert_not_nil flash.notice
      assert_equal @article_data[:title], assigns(:article).title
    end
  
    should "edit article" do
      get :edit, :id => @article.to_param
      assert_response :success
      assert_equal @article.title, assigns(:article).title
      assert ! assigns(:article).content.blank?
    end

    should "get 404 error when editing non-existent article" do    
      assert_raise(ActionController::RoutingError) { get :edit, :id => "123" }  
    end

    should "update article" do      
      post :update, :id => @article.to_param,
        :article => @article.attributes.merge(:title => "I like ruby very much")
      
      assert_redirected_to article_path(@article.to_param)      
      assert_not_nil flash.notice
      assert_equal "I like ruby very much", assigns(:article).title
    end

    should "not update article with invalid data" do
      post :update, :id => @article.to_param,
        :article => @article.attributes.merge(:title => "I")
      
      assert_response :success
      assert_template :edit
      assert_not_nil flash.alert
      assert_equal "I", assigns(:article).title
    end

    should "convert tags string to array when updating article" do      
      post :update, :id => @article.to_param,
        :article => @article.attributes.merge(:tags => "ruby, rails, sinatra")
      
      assert_redirected_to article_path(@article.to_param)
      assert_not_nil flash.notice
      assert_equal %w{ ruby rails sinatra }, assigns(:article).tags
    end

    should "publish article" do
      post :publish, :id => @article.to_param
      assert_redirected_to articles_path
      assert_not_nil flash.notice
      assert assigns(:article).visible
      assert assigns(:article).published_at
    end

    should "hide article" do
      post :hide, :id => @article.to_param
      assert_redirected_to articles_path
      assert_not_nil flash.notice
      assert ! assigns(:article).visible
    end

  end
  
end
