require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
 
  setup do
    @article = Factory.build(:article)
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
      @ruby_tag = Factory.create(:tag, :name => "ruby")
      @rails_tag = Factory.create(:tag, :name => "rails")
      @sinatra_tag = Factory.create(:tag, :name => "sinatra")
      
      Factory.create(:article,
        :title => "I like ruby",
        :content => "Lorem Ipsum",
        :published_at => Time.parse("10.02.2011"),
        :tags => [ @ruby_tag ],
        :visible => true
      )

      Factory.create(:article,
        :title => "I like ruby on rails",
        :content => "Lorem Ipsum",
        :published_at => Time.parse("10.02.2011"),
        :tags => [ @ruby_tag, @rails_tag ],
        :visible => true
      )

      Factory.create(:article,
        :title => "I like sinatra",
        :content => "Lorem Ipsum",
        :published_at => Time.parse("12.02.2011"),
        :tags => [ @sinatra_tag ],
        :visible => true
      )
    end
    
    teardown do
      Article.all.each { |article| article.destroy }
      Tag.all.each { |tag| tag.destroy }
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

