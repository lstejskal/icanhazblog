require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  def setup
    @article = Factory.create( :article,
      :comments => 2.times.map { Factory.create(:comment) }
    )
    
    comment = Factory.build(:comment)
    
    @comment_data = {
      :user_nickname => comment.user_nickname,
      :user_location => comment.user_location,
      :title => comment.title,
      :content => comment.content
    }
    
    @blank_comment_data = {
      :user_nickname => "",
      :user_location => "",
      :title => "",
      :content => ""
    }
  end

  def teardown
    @article.destroy
  end

  context "admin user" do

    setup do      
      @admin_user = Factory.create(:admin_user)
      @controller.expects(:current_user).at_least(2).returns(@admin_user)
    end

    teardown do
      @admin_user.destroy
    end

    should "publish valid comment with auto-completed user data" do
      @comment_data.delete(:user_nickname)
      @comment_data.delete(:user_location)
      post :create, :article_id => @article.to_param, :comment => @comment_data

      assert_redirected_to article_path(@article.to_param)
      assert_not_nil flash.notice
      
      @article = Article.find(@article.to_param)
      assert_equal 3, @article.comments.count
      
      comment = @article.comments.where(:title => @comment_data[:title]).first
      assert_equal @admin_user.nickname, comment.user_nickname,
        "nickname should be set to admin nickname"
      assert_equal "", comment.user_location.to_s,
        "location should be blank"
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

    should "publish valid comment" do
      post :create, :article_id => @article.to_param, :comment => @comment_data

      assert_redirected_to article_path(@article.to_param)
      assert_not_nil flash.notice
      
      # OPTIMIZE reloading article might not be necessary, try to use assigns(:articles)
      @article = Article.find(@article.to_param)
      assert_equal 3, @article.comments.count      
    end

    should "not publish valid comment under registered nickname" do
      registered_user = Factory.create(:user)
      @controller.expects(:current_user).at_least(2).returns(nil)
      @comment_data[:user_nickname] = registered_user.nickname
      
      post :create, :article_id => @article.to_param, :comment => @comment_data

      assert_response :success
      assert_template :show
      assert_not_nil flash.alert
      
      @article = Article.find(@article.to_param)
      assert_equal 2, @article.comments.count      
      
      registered_user.destroy
    end

    should "not publish invalid comment" do
      post :create, :article_id => @article.to_param, :comment => @blank_comment_data

      assert_response :success
      assert_template :show
      assert_not_nil flash.alert
      
      @article = Article.find(@article.to_param)
      assert_equal 2, @article.comments.count      
    end

    should "not delete comment" do
      @comment = @article.comments.first
      delete :destroy, :article_id => @article.to_param, :id => @comment.to_param

      assert_redirected_to article_path(@article.to_param)
      assert_not_nil flash.alert, "should fail with alert message"

      @article = Article.find( @article.to_param )
      assert_equal 2, @article.comments.count, "should not delete the comment"
    end

  end

end
