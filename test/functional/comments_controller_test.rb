require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  def setup
    @article = Factory.create( :article,
      :comments => 2.times.map { Factory.create(:comment) }
    )
  end

  def teardown
    @article.destroy
  end

=begin
  test "user should publish valid comment" do
    post :create, { }
    assert_response :success
  end

  test "user should not publish valid comment" do
    post :create
    assert_response :success
  end

  test "admin should publish valid comment" do
    post :create
    assert_response :success
  end

  test "admin should not publish invalid comment" do
    post :create
    assert_response :success
  end
=end

  context "admin user" do

    setup do      
      @admin_user = Factory.create(:admin_user)
      @controller.expects(:current_user).returns(@admin_user)
    end

    teardown do
      @admin_user.destroy
    end

    should "delete comment" do
      @comment = @article.comments.first
      delete :destroy, :article_id => @article.to_param, :id => @comment.to_param

      assert_redirected_to article_path(@article.to_param)
      assert_not_nil flash.notice

      @article = Article.find(@article.to_param)
      assert_equal 1, @article.comments.count
    end

  end

  context "ordinary user" do

    should "delete comment" do
      @comment = @article.comments.first
      delete :destroy, :article_id => @article.to_param, :id => @comment.to_param

      assert_redirected_to article_path(@article.to_param)
      assert_not_nil flash.alert, "should fail with alert message"

      @article = Article.find( @article.to_param )
      assert_equal 2, @article.comments.count, "should not delete the comment"
    end

  end

end
