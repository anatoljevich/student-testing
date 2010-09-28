
class Question < ActiveRecord::Base
  validates_presence_of :name, :message => 'Не задано название вопроса'
  validates_presence_of :text, :message => 'Не задан текст вопроса'
  validates_presence_of :answers, :message => 'Не заданы варианты ответов'

  belongs_to :topic, :counter_cache => true
  belongs_to :author

  attr_reader :correct_answers_text
  attr_reader :user_answers_text

  def get_answers
    raise NameError.new("Please implement 'get_answers'")
  end
  
  def correct_answers
    raise NameError.new("Please implement 'correct_answers'")
  end
  
  def collect_answers(texts, values)
    raise NameError.new("Please implement 'collect_answers'")
  end
  
  def add_answer
    raise NameError.new("Please implement 'add_answer'")
  end

  def correct_answer?(correct_answer, user_answer)
    raise NameError.new("Please implement 'correct_answer?'")
  end

  def report(answer)
    raise NameError.new("Please implement 'report'")
  end
  
  def get_report(answer, considered)
    qr = report(answer)
    qr.considered = considered
    qr
  end
  
  def remove
    Topic.decrement_counter(:questions_count, topic.id)
    update_attribute :deleted, true
  end
  
  protected
  def question_report(comments = nil)
    QuestionReport.new(topic.name, text, user_answers_text, correct_answers_text, comments) 
  end
  
  
  def validate
    # puts "answers_size=#{answers.size}"
    if answers.size >= Tests::Config::max_answers_size 
      errors.add_to_base "Слишком большой список вариантов ответа"
    end
    # puts "text_size=#{text.size}"
    if text.size >= Tests::Config::max_question_size
      errors.add_to_base "Слишком большой текст вопроса"
    end
  end
  
end
