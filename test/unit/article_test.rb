require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
 
  setup do
    @article = Factory.build(:article_ruby)
  end
  
  teardown do
    Article.all.each { |article| article.destroy }
  end

  context "When creating Article, it" do

    should "not save without title" do
      @article.title = nil
      assert ! @article.save
    end

    should "not save without content" do
      @article.content = nil
      assert ! @article.save
    end

    should "not save with title over max. length" do
      @article.title = random_string(251)
      assert ! @article.save
    end
    
    should "save only unique titles" do
      @article.save
      another_article = Factory.build(:article)
      another_article.title = @article.title
      assert ! another_article.save
    end
    
  end

  context "When listing articles, it" do

    setup do
      Factory.create(:article_ruby)
      Factory.create(:article_rails)
      Factory.create(:article_sinatra)
    end
    
    teardown do
      Article.all.each { |article| article.destroy }
    end

    should "show all articles available" do
      assert_equal 3, Article.list.count
    end

    should "show first page by default" do
      assert_equal 1, Article.list.current_page
    end

    should "show certain number of articles set by per_page parameter" do
      assert_equal 10, Article.list(:per_page => 10).per_page
    end

    should "show order articles by date in descending order by default" do
      assert_equal "I like sinatra", Article.list.first.title
    end

    should "not show hidden articles" do
      article = Article.first
      article.visible = false
      article.save
      
      assert_equal 2, Article.list.count
    end

    should "filter articles by tag" do
      articles = Article.list(:tag => 'ruby')
      
      assert_equal 2, articles.count
      assert_equal "I like ruby on rails", articles.first.title
      assert_equal "I like ruby", articles[1].title
    end

  end

  context "When finding article by id" do
    should "return Article if id exists" do
      @article.save
      assert_equal @article.title, Article.find(@article.to_param).title
    end
    
    should "raise exception if id doesn't exists" do
      assert_raise( BSON::InvalidObjectId ){ Article.find("123") }
    end
  end

  context "When sanitizing parameters for listing/search, it" do

    should "symbolize keys" do
      params = Article.sanitize_search_params("page" => 1, :per_page => 10)
      assert params.keys.include?(:page)      
      assert params.keys.include?(:per_page)
    end
  
    should "discard not-allowed parameters" do
      params = Article.sanitize_search_params("page" => 1, :id => 123)
      assert ! params.keys.include?(:id)
    end
    
  end

end

