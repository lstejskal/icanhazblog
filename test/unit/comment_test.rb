require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  context "Comment validation" do

    setup do
      @comment = Factory.build(:comment)
    end
  
    should "require title" do
      @comment.title = nil
      assert ! @comment.valid?
    end

    should "require content" do
      @comment.content = nil
      assert ! @comment.valid?
    end

    should "fail for title over max. length" do
      @comment.title = random_string(101)
      assert ! @comment.valid?
    end

    should "fail for content over max. length" do
      @comment.content = random_string(501)
      assert ! @comment.valid?
    end

    should "fail for user_nickname over max. length" do
      @comment.user_nickname = random_string(51)
      assert ! @comment.valid?
    end

    should "fail for user_location over max. length" do
      @comment.user_location = random_string(51)
      assert ! @comment.valid?
    end

    should "pass for valid data" do
      assert @comment.valid?
    end

  end

  context "Adding Comment to Article" do
    
    setup do
      @article = Factory.create( :article,
        :comments => 2.times.map { Factory.build(:comment) }
      )
    end
      
    teardown do
      @article.destroy
    end

    should "fail with invalid data" do
      @article.comments << Comment.new()
      assert ! @article.save
      assert_equal :comments, @article.errors.keys.first

      @article = Article.find(@article.to_param)
      assert_equal 2, @article.comments.count
    end
    
    should "succeed with valid data" do
      @article.comments << Factory.build(:comment)      
      @article = Article.find(@article.to_param)
      
      assert_equal 3, @article.comments.count
    end

  end

  context "Deleting comment by _id from article" do

    setup do
      @article = Factory.create( :article,
        :comments => 2.times.map { Factory.build(:comment) }
      )
    end
      
    teardown do
      @article.destroy
    end

    should "delete the Comment" do
      first_comment = @article.comments.first
      
      @article.comments.where("_id" => first_comment.id).delete_all
      @article = Article.find(@article.to_param)

      assert_equal 1, @article.comments.count
    end

  end

end
