
require 'nokogiri'
require 'open-uri'

class StudentScraper
  attr_accessor :main_index_url

  def initialize(main_index_url)
    @main_index_url = main_index_url
  end

  def call

    index_page = Nokogiri::HTML(open("#{self.main_index_url}"))

    students_array = index_page.css('li.home-blog-post div.blog-thumb a').collect do |link|
      link.attr('href')
    end
    students = []



      students_array.each do |student|
        # Scrape each student page
        student_website = "#{self.main_index_url}/#{student}"
        student_page = Nokogiri::HTML(open("#{student_website}")) rescue "404 Not Found"
next if student_page == "404 Not Found"
        
        name = student_page.css('h4.ib_main_header').text

        social_media = student_page.css('div.social-icons a').collect do |link|
          link.attr('href')
        end

        quote = student_page.css('div.textwidget h3').text

        text = student_page.css('div.services p').collect do |link|
          link.content.strip if link.element_children.empty?
        end
        text = text.compact

        # Insert data stored in variables into student_hash
        student_hash = {}
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

