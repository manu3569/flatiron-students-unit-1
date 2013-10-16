require_relative '../config/environment.rb'


scraper = StudentScraper.new("http://students.flatironschool.com/")
student_hashes=scraper.call
Student.import(student_hashes)
this = CLIStudent.new(Student.all)
this.call
