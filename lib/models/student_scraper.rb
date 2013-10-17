
class StudentScraper
  attr_accessor :student_page, :student

  def initialize(student)
    @student=student
    @student_page = Nokogiri::HTML(open(student.website))
  end

  def parse_all
    parse_name
    parse_profile_image
    parse_bg_image
    parse_twitter
    parse_linkedin
    parse_github
    parse_quote
    parse_bio
    parse_education
    parse_work
    parse_treehouse
    parse_code_school
    parse_coder_wall
    parse_blogs
    parse_favorite_cities
    parse_favorites
  end

  def parse_name
    student.name = student_page.css('h4.ib_main_header').text
  end

  def parse_twitter
    if twitter_node = student_page.at_css(".page-title .icon-twitter")
      student.twitter = twitter_node.parent.attr("href")
    end
  end

  def parse_github
    if github_node = student_page.at_css(".page-title .icon-github")
      student.github = github_node.parent.attr("href")
    end
  end

  def parse_linkedin
    if linkedin_page_node = student_page.at_css(".page-title .icon-linkedin-sign")
      student.linkedin = linkedin_page_node.parent.attr("href")
    end
  end

  def parse_quote
    student.quote = student_page.css('div.textwidget h3').text
  end

  def content_for(pattern)
    student_page.css("h3").each do |title_text| 
      if title_text.text.strip.match(pattern)
        return title_text.parent.parent.text.strip.sub(pattern, '').strip
      end
    end
    nil
  end

  def parse_profile_image
    image_path = student_page.css('.student_pic').attr("src").value
    student.profile_image = relative?(image_path) ? make_absolute(image_path) : image_path
  end  

  def parse_bio
    student.bio = content_for(/^Biography/i)
  end

  def parse_education
    student.education = content_for(/^Education/i)
  end

  def parse_work
    student.work = content_for(/^Work/i)
  end

  def parse_treehouse
    if treehouse_node = student_page.at_css("img[alt='Treehouse']")
      student.treehouse = treehouse_node.parent.attr("href")
    end
  end

  def parse_code_school
    if code_school_node = student_page.at_css("img[alt='Code School']")
      student.code_school = code_school_node.parent.attr("href")
    end
  end

  def parse_coder_wall
    if coder_wall_node = student_page.at_css("img[alt='Coder Wall']")
      student.coder_wall = coder_wall_node.parent.attr("href")
    end
  end

  def parse_blogs
    pattern = /^(Blogs?|Websites?)$/i
    student_page.css("h3").each do |title_text| 
      if title_text.text.strip.downcase =~ pattern
        student.blogs = title_text.parent.parent.css("a").collect do |link|
          { text: link.text, link: link.attr("href") }
        end
      end
    end
  end

  def parse_favorite_cities
    student_page.css("h3").each do |title_text| 
      if title_text.text.strip.downcase == "favorite cities"
        student.favorite_cities = title_text.parent.parent.css("a").to_a
      end
    end
  end

  def parse_favorites
    student_page.css("h3").each do |title_text| 
      if title_text.text.strip.downcase == "favorites"
        student.favorites = title_text.parent.parent.css("p").text.gsub(/^\s*- /,"")
      end
    end
  end

  def parse_bg_image
    background_style = student_page.css('style').text
    image_path = background_style.match(/background: url\(([^\)]+)/)[1]
    student.bg_image = relative?(image_path) ? make_absolute(image_path) : image_path
  end

  def make_absolute(path)
    "#{student.student_index}/students/#{path}"
  end

  def relative?(path)
    !path.match(/^https?:\/\//)    
  end
end

