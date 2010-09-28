require 'date'

class ReportController < ApplicationController

  before_filter :login_required
  ITEMS_ON_PAGE = 40

  def index
  end

  def show
    @exam = Exam.find_by_id params[:id]
    if @exam
      if params[:year] && params[:month] && params[:day]
        begin
          @date = Date.civil(params[:year].to_i, params[:month].to_i, params[:day].to_i) 
        rescue ArgumentError
          @date = session[:report_date]||=Date.today    
        end
      else
        @date = session[:report_date]||=Date.today    
      end
      if params[:condition] == '0'
        cond ="="    
      elsif params[:condition] == '1'
        cond = "<"
      elsif params[:condition] == '2'
        cond = ">"
      else
        cond = session[:report_cond]||="="
      end
      session[:report_date] = @date
      session[:report_cond] = cond
      page = params[:page] ?  params[:page].to_i : 1
      @entities = ExamEntity.paginate :per_page => ITEMS_ON_PAGE, :page => page, :conditions => ["exam_id= ? AND DATE(created_at)  #{cond} ?", @exam.id, @date]
    end
  end
  
  def clear
    @exam = Exam.find_by_id params[:id]
    if @exam
      if params[:year] && params[:month] && params[:day]
        begin
          @date = Date.civil(params[:year].to_i, params[:month].to_i, params[:day].to_i) 
          ExamEntity.destroy_all "exam_id = #{@exam.id} AND DATE(created_at) < '#{@date}'" 
        rescue ArgumentError
        end
      end
      redirect_to :action => 'show', :id => @exam.id
    end
  end
  
  def list
    @exam = Exam.find_by_id params[:id]    
    if @exam
      cond = session[:report_cond]
      @date = session[:report_date]
      cond = "=" unless cond
      @date = Date.today unless @date
      page = params[:page] ?  params[:page].to_i : 1
      @entities = ExamEntity.paginate :per_page => ITEMS_ON_PAGE, :page => page, :conditions => ["exam_id= ? AND DATE(created_at)  #{cond} ?", @exam.id, @date]
      render :action => 'show'
    end
  end
  
  def print
    @exam = Exam.find_by_id params[:id]
    if @exam
      @date = session[:report_date]||=Date.today
      @cond = session[:report_cond]||="="      
      @entities = @exam.examEntities.find :all, :conditions => [" DATE(created_at) #{@cond} ?", @date]
      @topics = @exam.examTopics.find :all, :include => :topic
    else
    end
    render :action => 'print', :layout => 'print'
  end
  
  def details
    @examEntity = ExamEntity.find_by_id_and_complete params[:id], true
    @report = @examEntity.report
  end
  
  def set_consider
    unless params[:number]
      flash[:notice] = 'Не найден ответ'
      redirect_to :action => 'index'
    end
    @examEntity = ExamEntity.find_by_id_and_complete params[:id], true
    if @examEntity 
      @examEntity.set_considered(params[:number].to_i)
      redirect_to :action => 'details', :id => @examEntity.id
    else
      flash[:notice] = 'Не найдена запись для экзамена'
      redirect_to :action => 'index'
    end
  end

  def unset_consider
    unless params[:number]
      flash[:notice] = 'Не найден ответ'
      redirect_to :action => 'index'
    end
    @examEntity = ExamEntity.find_by_id_and_complete params[:id], true
    if @examEntity 
      @examEntity.unset_considered(params[:number].to_i)
      redirect_to :action => 'details', :id => @examEntity.id
    else
      flash[:notice] = 'Не найдена запись для экзамена'
      redirect_to :action => 'index'
    end
  end


end
