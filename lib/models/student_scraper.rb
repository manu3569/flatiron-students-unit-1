
class StudentScraper
  attr_accessor :student_page, :student

  def initialize(student)
    @student=student
    @student_page = Nokogiri::HTML(open(student.website))
  end

  def parse_name
    student.name = student_page.css('h4.ib_main_header').text
  end

  def parse_twitter
    student.twitter = student_page.css('.page-title .icon-twitter').parent.attr("href").value
  end

  def parse_linkedin
    student.linkedin = student_page.css('.page-title .icon-linkedin-sign').parent.attr("href").value
  end

  def parse_github
    student.github = student_page.css('.page-title .icon-github').parent.attr("href").value
  end

  def call

    students = []
      students_array.each do |student|
        # Scrape each student page
        student_website = "#{self.main_index_url}/#{student}"
        student_page = Nokogiri::HTML(open("#{student_website}")) rescue "404 Not Found"
next if student_page == "404 Not Found"
        
        

        quote = student_page.css('div.textwidget h3').text

        text = student_page.css('div.services p').collect do |link|
          link.content.strip if link.element_children.empty?
        end
        text = text.compact

        # Insert data stored in variables into student_hash
        
        student_hash[:name] = name
        student_hash[:twitter] = social_media[0]
        student_hash[:linkedin] = social_media[1]
        student_hash[:github] = social_media[2]
        student_hash[:facebook] = social_media[3]
        student_hash[:website] = student_website
        student_hash[:quote] = quote
        student_hash[:bio] = text[0]
        student_hash[:work] = text[1]
        
        
        students << student_hash
      

    end
    students
  end
end

