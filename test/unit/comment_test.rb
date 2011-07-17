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

    should "delete the comment" do
      first_comment = @article.comments.first
      
      @article.comments.find(first_comment.id).destroy
      @article = Article.find(@article.to_param)

      assert_equal 1, @article.comments.count
    end

  end

  context "Finding comment by id in article" do

    setup do
      @article = Factory.create( :article,
        :comments => 2.times.map { Factory.build(:comment) }
      )
    end
      
    teardown do
      @article.destroy
    end

    should "raise exception with id belonging to other article" do
      @another_article = Factory.create( :article,
        :comments => [ Factory.build(:comment) ]
      )
      
      # TODO fix to work with assert_raise
      #
      @error = nil
      begin
        @article.comments.find(@another_article.comments.first.id)
      rescue Exception => e
        @error = e
      end
      
      assert @error.is_a?(Mongoid::Errors::DocumentNotFound)
        
      @another_article.destroy
    end

    should "succeed with valid id" do
      last_comment = @article.comments.last
      
      found_comment = @article.comments.find(last_comment.id)

      assert found_comment.is_a?(Comment)
      assert_equal last_comment.title, found_comment.title
    end

  end


end
