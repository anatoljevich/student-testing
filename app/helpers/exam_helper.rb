module ExamHelper
  def add_topic_link(name)
    link_to_function "<div class='button'>#{name}</div>", :class => 'add_link' do |page|
      page.insert_html :bottom, :exam_topics_box, :partial => 'exam_topic', :object => ExamTopic.new
    end 

  end
end
