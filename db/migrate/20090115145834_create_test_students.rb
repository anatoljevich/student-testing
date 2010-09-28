class CreateTestStudents < ActiveRecord::Migration
  def self.up
#    group = Group.create({:spec => 'TEST'.to_s, :number => 1})
#    group.students.create({:surname => 'Иванов', :name => 'Иван', :parent_name => 'Иванович', :code => '00000001' })
#    group.students.create({:surname => 'Петров', :name => 'Петр', :parent_name => 'Петрович', :code => '00000002' })
#    group.students.create({:surname => 'Алексеев', :name => 'Алексей', :parent_name => 'Алексеевич', :code => '00000003' })
#    group.students.create({:surname => 'Сергеев', :name => 'Сергей', :parent_name => 'Сергеевич', :code => '00000004' })
#    group.students.create({:surname => 'Дмитриев', :name => 'Дмитрий', :parent_name => 'Дмитриевич', :code => '00000005' })
 end

  def self.down
#    group = Group.find_by_spec_and_number "TEST", 1
#    group.students.clear if group
#    group.destroy
  end
end
