class StatController < ApplicationController
  before_filter :login_required
  
  def group
    all_topics_by_discipline
  end

  def topic
  end

  def topic_report
    @stat_report = StatTopicReport.new params[:stat_report]
    render :action => 'topic'
  end
  
  def group_report
    all_topics_by_discipline(params[:stat_report][:discipline_id])
    @stat_report = StatGroupReport.new params[:stat_report]
    render :action => 'group'
  end
  
  def question_report
    @stat_report = StatQuestionReport.new params[:stat_report]
    render :action => 'question'
  end
  
  def update_topic_selector
    all_topics_by_discipline(params[:discipline_id])
  end

  protected
  def all_topics_by_discipline(id = '0')
    @topics = [['Все', 0]]
    if id == '0'
      Topic.find(:all).each { |ti| @topics << [ti.name, ti.id] }
    else
      Topic.find_all_by_discipline_id(id).each { |ti| @topics << [ti.name, ti.id] }    
    end
  end

end
