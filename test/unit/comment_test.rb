require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  context "When creating Comment, it" do

    setup do
      @comment = Factory.build(:comment)
    end
      
    teardown do
      @comment.destroy
    end

    should "not save without title" do
      @comment.title = nil
      assert ! @comment.save
    end

    should "not save with content" do
      @comment.content = nil
      assert ! @comment.save
    end

    should "not save with title over max. length" do
      @comment.title = random_string(101)
      assert ! @comment.save
    end

    should "not save with content over max. length" do
      @comment.content = random_string(501)
      assert ! @comment.save
    end

    should "not save with user_nickname over max. length" do
      @comment.user_nickname = random_string(51)
      assert ! @comment.save
    end

    should "not save with user_location over max. length" do
      @comment.user_location = random_string(51)
      assert ! @comment.save
    end

    should "save with valid data" do
      assert @comment.save
    end

  end

  context "When adding Comment to Article, it" do

    setup do
      @article = Factory.create( :article,
        :comments => 2.times.map { Factory.create(:comment) }
      )
    end
      
    teardown do
      @article.destroy
    end

    should "not save with invalid data" do
      @article.comments << Comment.new()
      assert ! @article.save
      assert_equal :comments, @article.errors.keys.first

      @article = Article.find(@article.to_param)
      assert_equal 2, @article.comments.count
    end
    
    should "save with valid data" do
      @article.comments << Factory.build(:comment)      
      @article = Article.find(@article.to_param)
      
      assert_equal 3, @article.comments.count
    end

  end

  context "When deleting Comment from Article, it" do

    setup do
      @article = Factory.create( :article,
        :comments => 2.times.map { Factory.create(:comment) }
      )
    end
      
    teardown do
      @article.destroy
    end

    should "delete Comment from the list" do      
      @article.comments.first.destroy
      @article = Article.find(@article.to_param)

      assert_equal 1, @article.comments.count
    end

  end

end
