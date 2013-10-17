class SiteGenerator

  def initialize
    @students=Student.all
  end

  def generate
    generate_index
    generate_student_page
  end

  def generate_index
    create_page("index.html", "index.html.erb")
  end

  def generate_student_page
    @students.each do |student|
      @student=student
      create_page(
        "students/#{self.class.standardize_path(student.name)}.html",
       "show.html.erb"
      )
    end
  end

  def create_from_erb(template_path)
    ERB.new(File.open("lib/views/#{template_path}").read)  
  end  

  def create_page(write_path, template_path)
     File.open("_site/#{write_path}", "w+") do |f|
      f << create_from_erb(template_path).result(binding)
     end
  end

  def self.standardize_path(name)
    name.downcase.gsub(" ", "_")
  end


  def self.run
    sg = SiteGenerator.new()
    sg.generate
  end

end