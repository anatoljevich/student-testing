class ExamEntity < ActiveRecord::Base

  belongs_to :exam
  belongs_to :group
  belongs_to :student
  has_many :examEntityResults, :dependent => :destroy
  attr_reader :question
  attr_reader :qnumber
  attr_reader :number_of_questions

  def initialize(params)
    st = Student.find_by_id params[:student_id].to_i
    gr = Group.find_by_id params[:group_id].to_i
    @fio_validation_fails = true if st.nil?
    @group_validation_fails = true if gr.nil?
    @number_of_questions = 0
    super(params)
  end
  
  def generate_questions
#    exam.examTopics.each {|et| @number_of_questions += et.count }
    self.exam_variant = exam.exam_variant    
    @questions = []
    #выбрать все вопросы для exam
    all_questions = []
    exam.examTopics.collect {
      |et|
      @number_of_questions += et.count      
      et.topic
    }.each {
      |t| 
      all_questions << t.questions.find_all_by_deleted(false)
    }

    #случайно выбрать questions_count вопросов из @questions
    index = 0
    for et in exam.examTopics
      for i in 0...et.count
        random_index = rand(all_questions[index].size)
        random_question = all_questions[index][random_index]
        @questions << random_question
        all_questions[index].delete_at random_index
      end
      index += 1
    end
    
    #массив правильных ответов
    @correct_answers = Array.new(@questions.size)
    #массив ответов экзаменуемого
    @user_answers = Array.new(@questions.size)

    #запомнить правильные ответы на все вопросы
    for i in 0...@questions.size
      @correct_answers[i] = @questions[i].correct_answers
    end
    #обнуление счетчика вопросов
    @qnumber = 0
    save
  end
 
  def current_question
    return nil unless @user_answers.index nil
    @questions[@qnumber]   
  end

  def answer_question(as)
    #запомнить ответ на вопрос    
    @user_answers[@qnumber] = as.collect {|a| a.strip}.join(",")
    @qnumber += 1
    #найти неотвеченный вопрос
    if (@qnumber > @questions.size - 1)
      @qnumber = @user_answers.index nil
    else
      found = false
      for i in @qnumber..@questions.size-1
        @qnumber = i
        if @user_answers[@qnumber].nil?
          found = true
          break
        end
      end
      @qnumber = @user_answers.index(nil) unless found
    end
  end

  def goto_next
    @qnumber += 1 if @qnumber < (@user_answers.size - 1)
  end
  
  def goto_previous
    @qnumber -= 1 if @qnumber > 0  
  end

  def first_question?
    @qnumber == 0  
  end

  def last_question?
    @qnumber == (@questions.size - 1)
  end

  def answered?
    !@user_answers[@qnumber].nil?
  end

  def save_result

    res = REXML::Document.new '<res/>'
    
    correct_count = 0
    topic_overall = Hash.new
    topic_correct = Hash.new
    
    for i in 0...@questions.size do
      q = REXML::Element.new 'q'
      q.add_attribute 'id', @questions[i].id 
      topic_overall[@questions[i].topic_id] = topic_overall[@questions[i].topic_id].nil? ? 1 : topic_overall[@questions[i].topic_id] + 1
      
      if @questions[i].correct_answer?(@correct_answers[i], @user_answers[i])
        topic_correct[@questions[i].topic_id] = topic_correct[@questions[i].topic_id].nil? ? 1 : topic_correct[@questions[i].topic_id] + 1
        q.add_attribute 'correct', 'true' 
        correct_count += 1
      end

      q.add_element('c').add_text(@correct_answers[i])
      q.add_element('u').add_text(@user_answers[i])
      res.root.add_element q
    end
    
    topic_overall.each {
      |key, value|
      
      #add success topic or not :success => [true,false]
      examEntityResults.create({:topic_id => key, :total => value, :correct => (topic_correct[key].nil? ? 0 : topic_correct[key])})
    }

    success_topics = 0
    total_topics = 0
    exam.examTopics.each {
      |top|
      top_res = examEntityResults.find_by_topic_id(top.topic_id)
      total_topics += 1
      if top.passing_score <= top_res.correct*100/top_res.total
        success_topics += 1
        top_res.update_attribute :success, true
      end
    }

#    total_topics = exam.examTopics.size
    self.success_topics = success_topics
    self.total_topics = total_topics
    self.finished_at = Time.now
#    correct_count = correct_count
#    questions_count = @correct_answers.size
    self.result = res.to_s
    ExamResultEvaluator.score(self)
    self.complete = true
    save
  end

  def report
    res = []
    return res unless result
    doc = REXML::Document.new self.result
    doc.root.elements.each('/res/q')    {      
      |answer|
      if !answer.attributes['correct'] || answer.attributes['correct'].to_s == 'consider'
        ques = Question.find_by_id answer.attributes['id'].to_i
        res << ques.get_report(answer, answer.attributes['correct'])
      end
    }
    res
  end

  def set_considered(num)
    res = []
    return false unless result
    doc = REXML::Document.new self.result
    doc.root.elements.each('/res/q')    {      
      |answer|
      if !answer.attributes['correct'] || answer.attributes['correct'].to_s == 'consider'
        res << answer
      end
    }
    ans = res[num]
    if ans && !ans.attributes['correct'] #can't consider twice the same answer
      ans.add_attribute 'correct', 'consider'
      self.result = doc.root.to_s
      update_result
    else
      false
    end
  end
  
  def unset_considered(num)
    res = []
    return false unless result
    doc = REXML::Document.new self.result
    doc.root.elements.each('/res/q')    {      
      |answer|
      if !answer.attributes['correct'] || answer.attributes['correct'].to_s == 'consider'
        res << answer
      end
    }
    ans = res[num]
    if ans && ans.attributes['correct'] && ans.attributes['correct'].to_s == 'consider'
      ans.delete_attribute 'correct'
      self.result = doc.root.to_s
      update_result
    else
      false
    end
  end
  
  def update_result
    doc = REXML::Document.new result
    correct_count = 0
    topic_overall = Hash.new
    topic_correct = Hash.new
    
    doc.root.elements.each('/res/q')    {
      |answer|
      ques = Question.find_by_id answer.attributes['id'].to_i
      topic_overall[ques.topic_id] = topic_overall[ques.topic_id].nil? ? 1 : topic_overall[ques.topic_id] + 1
      if answer.attributes['correct']
        topic_correct[ques.topic_id] = topic_correct[ques.topic_id].nil? ? 1 : topic_correct[ques.topic_id] + 1        
        correct_count += 1        
      end
    }
    
    topic_overall.each {
      |key, value|
      #add success topic or not :success => [true,false]
      er = examEntityResults.find(:first, :conditions => ["topic_id=?", key])
      er.update_attribute :correct, (topic_correct[key].nil? ? 0 : topic_correct[key]) if er
    }
    
    success_topics = 0
    total_topics = 0
    exam.examTopics.each {
      |top|
      top_res = examEntityResults.find_by_topic_id(top.topic_id)
      total_topics += 1
      if top.passing_score <= top_res.correct*100/top_res.total
        success_topics += 1
        top_res.update_attribute :success, true
      end
    }

#    total_topics = exam.examTopics.size
    self.success_topics = success_topics
    self.total_topics = total_topics
#    self.finished_at = Time.now
#    correct_count = correct_count
#    questions_count = @correct_answers.size
#    self.result = res.to_s
    ExamResultEvaluator.score(self)
 #   self.complete = true
    save
  end

  def passed_percent
    if (success_topics && total_topics) && (total_topics != 0)
      (success_topics*100/total_topics).round
    else
      nil
    end
  end
   
  def minutes_left
    ml = (self.finished_at.nil? ? (self.exam.duration - (Time.now - self.created_at)/60).round : ((self.finished_at - self.created_at)/60).round)
    ml < 0 ? 0 : ml
  end

  def questions_left
    (@user_answers.size - @user_answers.compact.size)
  end
  
  protected
  
  def validate
    errors.add :fio, "Выберите свою фамилию из списка" if @fio_validation_fails
    errors.add :group, "Выберите группу" if @group_validation_fails      
  end
  
end
