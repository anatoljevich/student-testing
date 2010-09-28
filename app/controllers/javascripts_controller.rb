class JavascriptsController < ApplicationController
  layout nil
  before_filter :login_required
  
  def dynamic_topics
    @topics = Topic.find(:all)
  end
  
end
