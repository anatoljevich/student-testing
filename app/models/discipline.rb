class Discipline < ActiveRecord::Base
  has_many :topics
  validates_presence_of :name, :message => 'Не заполнено название дисциплины'
  
  def active?
    Exam.exists?(:discipline_id => self.id, :active => true)
  end
end
