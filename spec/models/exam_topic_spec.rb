require 'spec_helper'

describe ExamTopic do

  it "should be valid" do
    etopic = ExamTopic.new
    etopic.count = 50
    etopic.passing_score = 50
    etopic.topic = Topic.create(:name => 'topic', :questions_count => 100)
    etopic.should be_valid
  end
end
