class ExamTopic < ActiveRecord::Base
  
  belongs_to :exam
  belongs_to :topic

  validates_inclusion_of :count, :in => 1..100, :message => 'Количество вопросов должно находится в пределах от 1 до 100'
  validates_inclusion_of :passing_score, :in => 10..100, :message => 'Положительный результат должен находится в пределах от 10 до 100%'
  validates_presence_of :topic_id, :message => 'Необходимо выбрать тему экзамена'
  
  attr_accessor :should_destroy
#  attr_accessor :discipline_name

  def should_destroy?
    should_destroy.to_i == 1 
  end
  
  def validate
    if self.topic && self.count > self.topic.questions_count
      errors.add("count", "В указанной теме вопросов меньше чем в тесте") 
    end
  end

  
end
