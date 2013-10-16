
scraper = StudentScraper.new("http://students.flatironschool.com/")
student_hashes=student_scrape.call
Student.import(student_hashes)