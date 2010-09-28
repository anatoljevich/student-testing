class EditorController < ApplicationController
  before_filter :login_required
  before_filter :init_question, :only => [:question, :delete_question, :save_question]
  before_filter :init_discipline, :only => [:new_topic, :add_topic]
  before_filter :init_topic, :only => [:topic, :add_question, :edit_topic, :update_topic, :copy_questions]

  def index
    @disciplines = Discipline.find :all, :order => 'name'
  end
  
  def topic
    @disciplines = Discipline.find :all, :include => 'topics', :order => 'name'
    @questions = @topic.questions.find_all_by_deleted(false)
  end
  
  def add_discipline
    @disc = Discipline.new(params[:discipline])
    if @disc.save
      redirect_to :action => 'index', :id => @disc
    else
      render :action => 'new_discipline'
    end
  end
  
  def update_topic
    @topic.attributes = params[:topic]
    if @topic.save
      redirect_to :action => 'topic', :id => @topic
    else
      render :action => 'edit_topic'
    end
  end
  
  def add_topic
    @topic = @discipline.topics.build params[:topic]
    @topic.author = current_author
    if @topic.save
      redirect_to :action => 'topic', :id => @topic
    else
      render :action => 'new_topic'
    end
  end
  
  def question
    if @question
      @topic = @question.topic
      @topic.set_status current_author
      @answers = @question.get_answers
      render :action => view_action(@question)
    else
      flash[:notice] = 'Вопрос не найден'
      redirect_to :action => 'index'
    end
  end
  
  def delete_question
    if @question
      @topic = @question.topic
      @topic.set_status current_author
      if @topic.editable?      
        @question.remove
        flash[:notice] = 'Вопрос удален'
        redirect_to :action => 'topic', :id => @question.topic_id
      else
        flash[:notice] = @topic.status_message
        redirect_to :action => 'topic', :id => @question.topic_id        
      end
    else
      flash[:notice] = 'Вопрос не найден'
      redirect_to :action => 'index'
    end
  end
  
  def save_question
    if @question
      #update question
      @topic = @question.topic
      @topic.set_status current_author
      if @topic.editable?
        @question.attributes = params[:question]
        @question.author_id = current_author.id
        @question.collect_answers(params[:answers], params[:results])
		    unless @question.save
			    @answers = @question.get_answers
        	render :action => view_action(@question) and return 
		    end
      end
    else
      #create new question
      if params[:type] == 'TestQ'
        @question = TestQ.new params[:question]
      elsif params[:type] == 'WordQ'
        @question = WordQ.new params[:question]
      elsif params[:type] == 'SeqQ'
        @question = SeqQ.new params[:question]      
      end      
      @topic = @question.topic
      @topic.set_status current_author
      if @topic.editable?
        @question.author_id = current_author.id      
        @question.collect_answers(params[:answers], params[:results])
        unless @question.save
          @answers = @question.get_answers          
          render :action => view_action(@question) and return 
        end
      end
    end
    redirect_to :action => 'topic', :id => @question.topic_id
  end
  
  def add_question
    if @topic.editable?
      if params[:type] == 'TestQ'
        @question = TestQ.new({:topic_id => @topic.id,:name => 'Новый вопрос', :text => 'Новый вопрос', :author_id => @current_author })
      elsif params[:type] == 'WordQ'
        @question = WordQ.new({:topic_id => @topic.id,:name => 'Новый вопрос', :text => 'Новый вопрос', :author_id => @current_author })        
      elsif params[:type] == 'SeqQ'
        @question = SeqQ.new({:topic_id => @topic.id,:name => 'Новый вопрос', :text => 'Новый вопрос', :author_id => @current_author })        
      else
        flash[:notice] = 'Выберите корректный тип вопроса'
        redirect_to :action => 'topic', :id => @topic.id and return
      end
      @question.add_answer
      @answers = @question.get_answers
      render :action => view_action(@question)
    else
      flash[:notice] = @topic.status_message
      redirect_to :action => 'topic', :id => @topic        
    end
  end
  
  def copy_questions
    if @topic.editable?      
      questions = Question.find :all, :conditions => { :id => params[:questions]}
      flash[:notice] = "#{@topic.copy_questions(questions)} вопросов скопировано в тему '#{@topic.name}'"
    else
      flash[:notice] = @topic.status_message
    end
    redirect_to :back       
  end
  
  def add_test_answer
      render :update do |page|
        page.insert_html :bottom, 'answers', :partial => 'new_test_answer'
      end
  end

  def add_word_answer
      render :update do |page|
        page.insert_html :bottom, 'answers', :partial => 'new_word_answer'
      end
  end

  def add_seq_answer
      render :update do |page|
        page.insert_html :bottom, 'answers', :partial => 'new_seq_answer'
      end
  end

  def question_preview
    @text = params[:question][:text] if params[:question]
  end

  protected
  def view_action(question)
    return 'test_question' if question.class == TestQ
    return 'word_question' if question.class == WordQ
    return 'sequence_question' if question.class == SeqQ
  end

  def init_question
    @question = Question.find_by_id_and_deleted(params[:id], false)    
  end
  
  def init_discipline
    @discipline = Discipline.find_by_id(params[:id])    
  end
  
  def init_topic
    @topic = Topic.find_by_id(params[:id])    
    if @topic
      @topic.set_status current_author
      return true
    else
      flash[:notice] = 'Тема не найдена'
      redirect_to :action => 'index' and return
    end
  end
  
end
