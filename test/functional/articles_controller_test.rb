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
  
=begin
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create article" do
    assert_difference('Article.count') do
      post :create, :article => @article.attributes
    end

    assert_redirected_to article_path(assigns(:article))
  end

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
