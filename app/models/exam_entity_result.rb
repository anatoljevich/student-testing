class ExamEntityResult < ActiveRecord::Base
  belongs_to :examEntity
  belongs_to :topic
  
  def percent
    if self.total == 0
      0
    else
      (self.correct*100.to_f/self.total).round      
    end
  end
  
end
