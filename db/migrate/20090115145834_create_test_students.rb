class CreateTestStudents < ActiveRecord::Migration
  def self.up
    group = Group.create({:spec => "TEST", :number => 1})
    group.students.create({:surname => "Студент1", :name => 'Иван', :parent_name => 'Иванович', :code => '00000001' })
    group.students.create({:surname => "Студент2", :name => 'Петр', :parent_name => 'Петрович', :code => '00000002' })
    group.students.create({:surname => "Студент3", :name => 'Алексей', :parent_name => 'Алексеевич', :code => '00000003' })
    group.students.create({:surname => "Студент4", :name => 'Сергей', :parent_name => 'Сергеевич', :code => '00000004' })
    group.students.create({:surname => "Студент5", :name => 'Дмитрий', :parent_name => 'Дмитриевич', :code => '00000005' })
    group.students.create({:surname => "Студент6", :name => 'Андрей', :parent_name => 'Андреевич', :code => '00000006' })
    group.students.create({:surname => "Студент7", :name => 'Александр', :parent_name => 'Александрович', :code => '00000007' })
    group.students.create({:surname => "Студент8", :name => 'Федор', :parent_name => 'Федорович', :code => '00000008' })    
    group.students.create({:surname => "Студент9", :name => 'Акакий', :parent_name => 'Акакиевич', :code => '00000009' })    
    group.students.create({:surname => "Студент10", :name => 'Николай', :parent_name => 'Николаевич', :code => '00000010' })
  end

  def self.down
    group = Group.find_by_spec_and_number "TEST", 1
    group.students.clear if group
    group.destroy
  end
end
