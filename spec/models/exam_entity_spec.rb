require 'spec_helper'

describe ExamEntity do
  fixtures :exam_entities, :exams, :exam_topics, :disciplines, :questions, :topics

  it "should generate questions xml and fill result with correct answers and count questions" do
    entity = exams('capitals').examEntities.build
    entity.generate_questions
    result_dom = REXML::Document.new entity.result
    for i in 0...entity.exam.examTopics.size
      et = entity.exam.examTopics[i]
      topic_element = result_dom.get_elements('/res/t')[i]
      topic_element.attributes['id'].should == et.id.to_s
      topic_element.get_elements('q').each do |question_element|
        question = et.topic.questions.find(:first, :conditions => {:id => question_element.attributes['id'], :deleted => false})
        question_element.get_elements('c').first.text.should == question.correct_answers
      end
    end
    entity.questions_count.should == entity.exam.examTopics.to_a.sum(&:count)
    entity.current_question_number.should == 0
  end
end
