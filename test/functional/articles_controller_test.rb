require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  def setup
    @article = Factory.create(:published_article)    
  end

  def teardown
    Article.all.each { |article| article.destroy }
  end  

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
    assert_equal 1, assigns(:articles).size
  end

  test "should show article with valid id" do
    get :show, :id => @article.to_param
    assert_response :success
  end
  
  test "should return 404 if article can't be found" do    
    assert_raise(ActionController::RoutingError) { get :show, :id => "123" }  
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
