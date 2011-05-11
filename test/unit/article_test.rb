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

    should "generate alias from title" do
      @article.save
      assert_equal @article.alias, @article.title.parameterize
    end
    
  end

  context "When editing Article, it" do

    should "automatically update alias if title changes" do
      @article.save
      new_title = "Big News!"
      @article.update_attributes(:title => new_title)
      assert_equal @article.alias, new_title.parameterize
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

    should "filter articles by day" do
      articles = Article.list(:from => '05.02.2011', :to => '05.02.2011')
      
      assert_equal 1, articles.count
      assert_equal "I like ruby", articles.first.title
    end

    should "filter articles by date range" do
      articles = Article.list(:from => '08.02.2011', :to => '10.02.2011')
      
      assert_equal 1, articles.count
      assert_equal "I like ruby on rails", articles.first.title
    end

    should "throw away invalid date attributes" do
      articles = Article.list(:from => '08.20.2011', :to => '10.02.2011')
      
      assert_equal 3, articles.count
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

  context "When finding article by alias" do
    should "alias should be by default equal to parameterized title" do
      @article.save
      assert_equal @article.alias, @article.title.parameterize
    end
    
    should "return Article if alias exists" do
      @article.save
      assert_equal @article.title, Article.find_by_alias(@article.alias).title
    end
    
    should "return nil if alias doesn't exists" do
      assert_nil Article.find_by_alias("123")
    end
  end

  context "Article#publish method" do
    should "publish new article" do
      @article = Factory.build(:unpublished_article)
      @article.publish!
      assert @article.visible?
      assert_kind_of DateTime, @article.published_at
      assert_equal Date.current, @article.published_at.to_date
    end

    should "make hidden article visible to users" do
      @article.hide!
      @article = Article.find(@article.to_param)
      orig_published_at = @article.published_at
      @article.publish!

      assert @article.visible?
      assert_kind_of DateTime, @article.published_at
      assert_not_equal Date.current, @article.published_at.to_date
      assert_equal orig_published_at.to_date, @article.published_at.to_date
    end
  end

  context "Article#hide method" do
    should "hide article from users" do
      @article.hide!
      assert ! @article.visible?
    end
  end

  context "Article.recent method" do
    setup do
      Factory.create(:article_ruby)
      Factory.create(:article_rails)
      Factory.create(:article_sinatra)
    end
    
    should "return specific number of recently published articles" do
      articles = Article.recent(2)
      assert_equal 2, articles.count
    end

    should "order articles  by date in descending order" do
      articles = Article.recent
      assert "I like sinatra", articles.first.title
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
  
  context "Article protected attributes" do

    should "not be saved by mass assignment" do
      article = Article.create(@article.attributes)        
      assert ! article.published_at
    end  

  end

end

