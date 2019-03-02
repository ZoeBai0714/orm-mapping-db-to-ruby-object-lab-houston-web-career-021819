require 'pry'
class Student
  attr_accessor :id, :name, :grade
   
  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end



  def self.all
   result = DB[:conn].execute(
      "SELECT * FROM students"
     )
   result.map do |student|
     self.new_from_db(student) #use the method built above converting each row into an instance
   end
  end



  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    row = DB[:conn].execute(
        "SELECT * FROM students WHERE name = ?",   #find the student in DB
        [name]
      )
    #binding.pry  
    self.new_from_db(row[0])  #convert a row into an instance
  end
  
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def all_students_in_grade_9
  end
end