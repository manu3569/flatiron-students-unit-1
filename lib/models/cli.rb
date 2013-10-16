require_relative './student.rb'
require_relative './student_scrape.rb'

# for the Student Site, maybe CLIStudent, so that:
# CLIStudent.new(students) # Where students
# are a bunch of student instances.


class CLIStudent
  attr_accessor :students

  def initialize(students)
    @students = students
  end

  def exit
    puts "Goodbye!"
  end
    
  def browse
    @students.each {|student|
      puts "#{student.id} is #{student.name} "
    }
    self.call
  end

  def help
    self.call
  end
     
  def find
    found = false
    puts " you can type an id or a name "
    looking_for = gets.chomp
    if looking_for.to_i > 0
      @students.find {|student|
      if student.id == looking_for.to_i
        found= true
        puts "#{student.name}"
        puts "would you like to see more info? (y/n)"
        ans= gets.chomp
        if ans == "y"
          puts "Bio: #{student.bio}"
          puts "Quote: #{student.quote}"
        end
       end
      }
    else
      @students.find {|student|
      if student.name == looking_for
        found= true
        puts "#{student.name}"
        puts "would you like to see more info?(y/n)"
        ans= gets.chomp
        if ans == "y"
          puts "Bio: #{student.bio}"
          puts "Quote: #{student.quote}"
        end
      end
      }
    end
    if found== false
      puts "\n No such student maybe browse?"
      puts "press enter to continue \n\n\n"
      gets
    end
    self.call
  end

  def call

    puts "\n\n\n----------------------------------------"
    puts "you can type help for list of commands"
    puts "or type browse to list all students"
    puts "you can always exit by typing exit"
    puts "to find students by name or id call find"
    puts "\n\n\n----------------------------------------"
    command=gets.chomp
    case command
      when 'browse' then browse
      when 'exit' then exit
      when 'find' then find
      when 'help' then help
      else
      puts ">>>>>>>>I am not sure what you are trying to do<<<<<<<<<<"
      self.call
    end
  end

end


main_index_url = "http://students.flatironschool.com/"

student_scrape = StudentScraper.new(main_index_url)

student_hashes = student_scrape.call

Student.import(student_hashes)