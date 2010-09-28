class FillDisciplines < ActiveRecord::Migration
  def self.up
#    Discipline.create({:name => 'Информатика'})
#    Discipline.create({:name => 'Организация труда'})
  end

  def self.down
    Discipline.destroy_all
  end
end
