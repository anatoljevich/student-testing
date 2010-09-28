class QuestionReport

  attr_reader :topic
  attr_reader :text
  attr_reader :user_answer
  attr_reader :correct_answer
  attr_accessor :considered
  attr_reader :comments

  def initialize(topic, text, user_answer, correct_answer, considered, comments = nil)
    @topic = topic
    @text = text
    @user_answer = user_answer    
    @correct_answer = correct_answer
    @considered = considered
    @comments = comments
  end
  
end