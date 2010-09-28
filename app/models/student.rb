class Student < ActiveRecord::Base
  belongs_to :group, :counter_cache => true

  validates_presence_of :surname, :message => 'Не заполнена фамилия'  
  validates_presence_of :name, :message => 'Не заполнено имя'  
  validates_presence_of :parent_name, :message => 'Не заполнено отчество'  
  validates_presence_of :code, :message => 'Не заполнен номер зачетной книжки'  
  validates_presence_of :group_id, :message => 'Не выбрана группа'  
  
  def fio
    "#{surname} #{name} #{parent_name}"
  end

  def remove
    group.decrement! :students_count
    update_attribute :deleted, true
  end

  
end
