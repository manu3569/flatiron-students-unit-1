require_relative '../config/environment.rb'

scraper = IndexScraper.new("http://students.flatironschool.com/")
scraper.parse_index

Student.all.each do |student|
  StudentScraper.new(student).parse_all

end  

SiteGenerator.run