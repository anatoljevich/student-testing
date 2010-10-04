class ExamController < ApplicationController
  before_filter :login_required
  before_filter :init_exam, :only => [:edit, :update, :start_stop, :delete]
  skip_before_filter :verify_authenticity_token, :only => [:start_stop]

  def index
    @exams = Exam.find :all
  end

  def new
    @exam = Exam.new
    @exam.examTopics.build
  end
  
  def create
    @exam = Exam.new params[:exam]
      if @exam.save
      flash[:notice] = 'Экзамен создан'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def update
    if @exam
      if @exam.active
        flash[:notice] = 'Невозможно редактировать активный тест'
        redirect_to :action => 'index'
      elsif @exam.update_attributes params[:exam]
        flash[:notice] = 'Изменения сохранены'
        redirect_to :action => 'index'
      else
        render :action => 'edit'
      end
    else
      flash[:notice] = 'Экзамен не найден'
      redirect_to :action => 'index'
    end
  end
  
  def delete
    if @exam
      if @exam.active
        flash[:notice] = 'Невозможно удалить активный экзамен'
      else
        if @exam.examEntities.size > 0
          flash[:notice] = 'Необходимо удалить все результаты этого экзамена'
        else
          @exam.destroy
        end
      end
    end
    redirect_to :action => 'index'
  end
  
  def start_stop
    if @exam.active
      @exam.stop
      flash[:notice] = "Тест '#{@exam.description}' остановлен"
    elsif @exam.start
      flash[:notice] = "Тест '#{@exam.description}' активирован"      
    else
      flash[:notice] = "Невозможно активировать экзамен. Проверьте наличие тем и вопросов"      
    end
    redirect_to :action => 'index'
  end
  
  protected
    
  def init_exam
    @exam = Exam.find_by_id(params[:id])    
  end
end
