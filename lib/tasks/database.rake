
namespace :db do

  desc "generate random articles (ARTICLES_NR, 10 by default) with tags and comments"
  task :generate_random_articles => :environment do
    
    articles_nr = ((ENV['ARTICLES_NR'] =~ /^\d+$/) ? ENV['ARTICLES_NR'].to_i : 10)
    
    (1..articles_nr).to_a.each do |i|
      article = Factory.build(:article)
      3.times { Factory.create(:comment, :article => article) }
      puts "#{i}. #{article.title}"
    end
    
  end
    
end
