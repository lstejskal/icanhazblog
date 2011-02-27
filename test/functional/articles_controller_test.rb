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

    should "view article" do
      get :show, :id => @article.to_param
      assert_response :success
      assert_equal @article.to_param, assigns(:article).to_param
    end
  
    should "get 404 error when viewing non-existent article" do    
      assert_raise(ActionController::RoutingError) { get :show, :id => "123" }  
    end
  
  end
  
  context "admin user" do

    setup do
      @article_data = {
        :title => "I like blogging",
        :content => "<p>Man, how do I like blogging and sharing my<br />" +
          "thoughts with the world!</p>"
      }
      
      @controller.expects(:admin_access_required).returns(true)
      @controller.expects(:admin?).at_least(1).returns(true)
    end

    should "view admin list of articles" do
      get :index
      assert_response :success
      assert_template "admin_index"
      assert_equal 3, assigns(:articles).size
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

    # TODO add integration tests: publish/hide article, then check if there's
    # one more/less article in the list of articles...

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
