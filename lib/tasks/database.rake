
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

  desc "export articles into JSON file (EXPORT_FILE or 'exported_articles_TIMESTAMP.json')"
  task :export_articles => :environment do
  
    ENV['EXPORT_FILE'] ||= "exported_articles_#{Time.now.strftime('%d-%m-%Y_%H-%M')}.json"

    File.open(ENV['EXPORT_FILE'], 'w') do |f|
      f.puts "[\n" + Article.all.map { |article| article.attributes.to_json }.join(",\n") + "\n]"
    end

    puts "Done, #{Article.count} articles exported into '#{ENV['EXPORT_FILE']}'."    
  end

  # PS: import is meant to be done by throwaway scripts, this is just for validaning exported articles
  # This is just a quick check, to properly test, load into database or write tests
  desc "test exported articles from EXPORT_FILE"
  task :test_export do
  
    raise Exception, "EXPORT_FILE env. variable is not set!" unless ENV['EXPORT_FILE']

    begin
      articles = JSON::parse(File.read(ENV['EXPORT_FILE']))

      puts "Exported #{articles.size} articles, it looks OK."
    rescue => e
      puts "Export file is invalid:\n#{e}"
    end
  end
    
end
