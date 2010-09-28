class Exam < ActiveRecord::Base
  
  has_many :examEntities, :dependent => :destroy, :order => "id DESC"
  has_many :examTopics, :dependent => :destroy
  
  after_update :save_topics
  
  validates_inclusion_of :exam_variant, :in => Tests::Config::exam_variants.to_a.collect {|v| v[0]}, :message => 'Выберите тип теста'
  validates_presence_of :description, :message => 'Не заполнено описание теста'
  validates_inclusion_of :duration, :in => 1..90, :message => 'Продолжительность теста должна быть от 1 до 90 минут'
  validates_inclusion_of :passing_score, :in => 10..100, :message => 'Положительный результат должен находится в пределах от 10 до 100%'  
  validates_associated :examTopics

  def self.DEFAULT_DURATION
    45
  end

  def self.DEFAULT_PASSING_SCORE
    50
  end

  def self.DEFAULT_QUESTIONS_COUNT
    20
  end
  
  def topic_attributes=(attributes)
    attributes.each do |attrs|
      if attrs[:id].blank?
        examTopics.build attrs      
      else
        topic = examTopics.detect { |t| t.id == attrs[:id].to_i }
        topic.attributes = attrs
      end
    end
  end
  
  def stop
    update_attribute :active, false    
  end
  
  def start
    can_start = true
    examTopics.find(:all, :include => :topic).each {
      |t|
      can_start = false if t.topic.questions_count < t.count
    }
    update_attribute(:active, true) if can_start
    can_start
  rescue
    false
  end
  
  protected

  def save_topics
    examTopics.each do |t|  
      if t.should_destroy?
        t.destroy
      else
        t.save(false)      
      end
    end
  end
  
  def validate
    if examTopics.empty?
      errors.add_to_base 'Не выбрана тема для теста'
      return
    end
    if examTopics.collect{ |et| et.topic_id }.uniq.size != examTopics.size
      errors.add_to_base 'Нельзя дважды добавлять одну и ту же тему в экзамен'
    end
  end
end
