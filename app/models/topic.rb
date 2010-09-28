class Topic < ActiveRecord::Base
  belongs_to :discipline
  belongs_to :author
  
  has_many :questions
  has_many :examTopics
  has_many :examEntityResults, :dependent => :destroy
  
  attr_reader :status_message
  
  validates_presence_of :name, :message => 'Не заполнено название темы'

  def editable?
    @editable
  end
  
  def can_change_rights?
    @rights
  end

  def set_status(user)
    @rights = false
    @editable = false      
    if activated?
      # if test is activated no one can edit or change rights
      @status_message = 'Деактивируйте все тесты, использующие данную тему, для внесения в нее изменений'  
    elsif topic_superuser?(user)
      # admin or author can edit topic and change rights
      @rights = true
      @editable = true
    else
      # user can't change rights even for public topic
      if public
        # but user can edit public topic
        @editable = true
      else
        #user can't edit private topic
        @status_message = 'Только автор и администратор могут редактировать темы, для которых не включен общий доступ.'
      end
    end
  end
  
  def copy_questions(qs)
    count = 0
    qs.each {
      |q|
      if q.topic_id != self.id
        copied = q.clone
        self.questions << copied
        if copied.save
#          self.increment!(:questions_count)
          count += 1
        end
      end
    }
    count
  end
  
  protected
  
  def activated?
    exams = Exam.find_all_by_active true
    for exam in exams
      return true if exam.examTopics.collect{|et| et.topic_id }.include?(self.id)
    end
    false
  end
  
  def topic_superuser?(user)
    (user == author) || user.admin?
  end
  
end
