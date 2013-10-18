require_relative '../config/environment.rb'


# scraper = StudentScraper.new("http://students.flatironschool.com/")
# student_hashes=scraper.call
# Student.import(student_hashes)

scraper = IndexScraper.new("http://students.flatironschool.com/")
scraper.parse_index

Student.all.each do |student|
  StudentScraper.new(student).parse_all
end  

this = CLIStudent.new(Student.all)
this.call
