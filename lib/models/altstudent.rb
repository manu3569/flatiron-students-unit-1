require 'sqlite3'
require 'pry'


class Student
  attr_accessor :name, :twitter, :linkedin, :facebook, :website, :quote, :bio, :work, :id
  @@students = []
  @@db = SQLite3::Database.new 'students.db'
  create_table = "CREATE TABLE IF NOT EXISTS student(id INTEGER PRIMARY KEY,
name TEXT,
twitter TEXT,
linkedin TEXT,
facebook TEXT,
website TEXT,
quote TEXT,
bio TEXT,
work TEXT);"

  @@db.execute(create_table)

  def initialize(hash=nil)
    if !hash.nil?
      @name = hash[:name]
      @twitter = hash[:twitter]
      @linkedin = hash[:linkedin]
      @github = hash[:github]
      @facebook = hash[:facebook]
      @website = hash[:website]
      @quote = hash[:quote]
      @bio = hash[:bio]
      @work = hash[:work]
    end
    @@students << self
    @id = @@students.size
  end

###### Save methods
  def save
    saved? ? update : insert
  end

  def saved!
    @saved = true
  end
 
  def saved?
    @saved
  end

###### Find methods

  def self.all
    @@students
  end

  def self.reset_all
    @@students = []
  end

  def self.find_by_name(name)
    @@students.select {|student| student if student.name == name }
  end

  def self.dbfind_by_name(name)
    find= "SELECT * FROM student WHERE name =?"
    result = @@db.execute(find, name)
  end

  def self.dbfind(id)
    find = "SELECT * FROM student WHERE id = ?"
    result = @@db.execute(find, id)
  end

  def self.find(stid)
    @@students.find {|student| student.id == stid}
  end


###### Update & Insert

  def insert
    sql = "INSERT INTO student VALUES (?,?,?,?,?,?,?,?,?)"
    @@db.execute(sql, self.id, self.name, self.twitter, self.linkedin,
      self.facebook, self.website, self.quote, self.bio, self.work)
    find = "SELECT id FROM student WHERE name = ? ORDER BY id DESC LIMIT 1"
    results = @@db.execute(find, self.name)
    @id = results.flatten.first
    saved!
  end

  def update
    if saved?
    sql = "UPDATE student SET name = ? WHERE id = ?"
    @@db.execute(sql, self.name, self.id)
    saved!
    end
  end

   def update_quote
    if saved?
    sql = "UPDATE student SET quote = ? WHERE id = ?"
    @@db.execute(sql, self.quote, self.id)
    end
  end

###### Deletes
  def self.delete(stid)
    @@students.delete_if {|student| student.id == stid }
  end

  def self.db_reset
    sql="DELETE FROM student"
    @@db.execute(sql)
  end

  def self.dbdelete(id)
    delete="DELETE FROM student WHERE id = ?"
    @@db.execute(delete, id)
  end

###### Reconstruct obj
  def self.load(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.twitter = row[2]
    student.linkedin = row[3]
    student.facebook = row[4]
    student.website = row[5]
    student.quote = row[6]
    student.bio = row[7]
    student.work = row[8]
    student.saved!
    student
  end


  def self.import(student_hashes)
    student_hashes.each do |student|
      stu= Student.new(student)
      #stu.save
    end
    #binding.pry
  end
  
end

 





