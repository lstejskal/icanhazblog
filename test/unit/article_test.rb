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

end
