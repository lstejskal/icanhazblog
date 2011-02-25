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

  end
  
=begin
  test "should get edit" do
    get :edit, :id => @article.to_param
    assert_response :success
  end

  test "should update article" do
    put :update, :id => @article.to_param, :article => @article.attributes
    assert_redirected_to article_path(assigns(:article))
  end
=end
  
end
