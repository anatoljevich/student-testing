class GroupController < ApplicationController
  before_filter :login_required
  before_filter :init_group, :only => [:new_student, :add_student, :group]
  before_filter :init_student, :only => [:edit_student, :delete_student, :student]
  def index
    @groups = Group.find :all, :order => 'spec, number'
  end
  
  def group
    @students = @group.students
  end
  
  def add_student
    @student = @group.students.build params[:student]
    if @student.save
      redirect_to :action => 'group', :id => @group
    else
      render :action => 'new_student'
    end
  end
  
  def edit_student
    @student.attributes = params[:student]
    if @student.save
      redirect_to :action => 'group', :id => @student.group_id
    else
      render :action => 'student'
    end
  end
  
  def delete_student
    if @student && !@student.deleted
      @student.remove
      flash[:notice] = "Студент #{@student.fio} удален из списка группы #{@student.group.name}"
      redirect_to :action => 'group', :id => @student.group_id
    else
      flash[:notice] = 'Студент не найден'
      redirect_to :action => 'index'
    end
  end
  
  def add_group
    @group = Group.new params[:group]  
    if @group.save
      redirect_to :action => 'index'
    else
      render :action => 'new_group'
    end
  end
  
  protected
  def init_group
    @group = Group.find_by_id params[:id]
  end
  
  def init_student
    @student = Student.find_by_id params[:id]
  end
end
