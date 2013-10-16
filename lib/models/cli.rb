
class CLIStudent
  attr_accessor :students

  def initialize(students)
    @students = students
    @prompt = "enter your command #=>> "
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
     
  def input
    gets.downcase.strip
  end

  def query_more_info(student)
    puts "Would you like to see more info? (y/n)"
    ans= input
    if ans == "y"
      puts "\n\n**********************"
      puts "Bio: #{student.bio}"
      puts "Quote: #{student.quote}"
      puts "**********************\n\n"
    end
  end

  def find
    found = false
    puts " you can type an id or a name "
    looking_for = input
    if looking_for.to_i > 0
      @students.find {|student|
      if student.id == looking_for.to_i
        found= true
        puts "#{student.name}"
        query_more_info(student)
       end
      }
    else
      @students.find {|student|
      if student.name.downcase.strip.include?(looking_for)
        found= true
        puts "#{student.name}"
        query_more_info(student)
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
    print @prompt
    command=input
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

