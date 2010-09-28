class UserController < ApplicationController

  def index
    @exams = Exam.find_all_by_active(true)
    render :action => 'index', :layout => 'application'
  end
  
  def agreement
    @exam = Exam.find_by_id_and_active(params[:id],true)    
  end
  
  def auth
    @exam = Exam.find_by_id_and_active(params[:id],true)
  end
  
  def list_students
    @students = Student.find :all, :conditions => ["group_id=?", params[:id]], :order => "surname"
    render :action => 'update_students_list'
  end
  
  def duration
    @examEntity = session[:examEntity]
    render :text => '' and return unless @examEntity
    minutes_left = @examEntity.minutes_left
    if minutes_left == 0 && !@examEntity.complete
      # finish test
      @examEntity.save_result
      render :update do |page|
        page.assign 'blockExit', false
        page.redirect_to "#{url_for :action => 'finish'}"
      end
    else
      render :update do |page|
        page.replace_html 'minutes_left', minutes_left
      end
    end
  end
  
  def agreement
    @exam_id = params[:id]
  end
  
  def start
    #вдруг в сессии осталась информация с прошлого запуска
    session[:examEntity] = nil
    
    @exam = Exam.find_by_id_and_active(params[:id],true)
    @examEntity = @exam.examEntities.build(params[:student])
    unless @examEntity.save
      render :action => 'auth' and return
    end
    @examEntity.generate_questions
    session[:examEntity] = @examEntity
    redirect_to :action => 'run'
  end
  
  def run
    @examEntity = session[:examEntity]
    redirect_to :action => 'index' and return unless @examEntity
    @question = @examEntity.current_question
    if @question
      @answers = @question.get_answers
    else
      redirect_to :action => 'index'
    end
  end
  
  def answer
    @examEntity = session[:examEntity]
    #сохранение ответа пользователя и переход на следующий вопрос

    @examEntity.answer_question params[:answers]
    #отображение следующего вопроса

    @question = @examEntity.current_question
    if @question
      @answers = @question.get_answers
      render :update do |page|
        page.replace_html  'current_answer', :partial => 'current_answer'
        page.replace_html  'questions_left', @examEntity.questions_left
      end
    else
      @examEntity.save_result
      render :update do |page|
        page.assign 'blockExit', false
        page.redirect_to "#{url_for :action => 'finish'}"
      end
    end
  end
  
  def break_test
    @examEntity = session[:examEntity]
    #сохранение ответа пользователя и переход на следующий вопрос
    @examEntity.save_result
    render :update do |page|
      page.assign 'blockExit', false
      page.redirect_to "#{url_for :action => 'finish'}"
    end
  end

  def finish
    @examEntity = session[:examEntity]    
    session[:examEntity] = nil
    render :partial => 'finish', :layout => 'user'
  end

  def next_answer
    @examEntity = session[:examEntity]
    #переход на следующий вопрос без сохранения ответа
    @examEntity.goto_next
    @question = @examEntity.current_question    
    @answers = @question.get_answers
    render :update do |page|
      page.replace_html  'current_answer', :partial => 'current_answer'
    end
  end
  
  def previous_answer
    @examEntity = session[:examEntity]
    #переход на следующий вопрос без сохранения ответа
    @examEntity.goto_previous
    @question = @examEntity.current_question    
    @answers = @question.get_answers
    render :update do |page|
      page.replace_html  'current_answer', :partial => 'current_answer'
    end
  end
end
