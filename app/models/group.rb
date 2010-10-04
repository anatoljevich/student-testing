class Group < ActiveRecord::Base
  has_many :exam_entities, :dependent => :destroy
  has_many :students, :conditions => "deleted = false", :dependent => :destroy
  validates_presence_of     :spec, :message => 'Название группы не может быть пустым'
  validates_presence_of     :number, :message => 'Номер группы не может быть пустым'

  def name
   "#{spec}-#{number}"  
  end
  
  protected 
  
  def validate
    #validates if number is not correct, if group exists
    #create name attribute
    
    if number == 0
      errors.add_to_base 'Необходимо ввести номер группы'
    end
    
    if Group.find_by_spec_and_number spec, number
      errors.add_to_base 'Указанная группа существует'
    end
  end

end
