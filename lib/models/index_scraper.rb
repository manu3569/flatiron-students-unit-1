class IndexScraper

  attr_reader :main_index_url

  def initialize(main_index_url)
    @main_index_url = main_index_url
    @index_page = Nokogiri::HTML(open(main_index_url))
  end

  def parse_index
    @index_page.css('li.home-blog-post').each do |student_data|
      student = Student.new
      student.website = "#{main_index_url}/" + student_data.css("div.blog-thumb a").attr("href").value
      student.index_image = student_data.css("img.prof-image").attr("src").value
      student.tagline = student_data.css("p.home-blog-post-meta").text.strip
      student.excerpt = student_data.css("div.excerpt p").text.strip
      student.student_index = main_index_url
    end
  end

end





