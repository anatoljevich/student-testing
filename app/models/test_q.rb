require 'rexml/document'
class TestQ < Question

  def get_answers
    result = []
    return result unless answers
    doc = REXML::Document.new answers
    doc.root.elements.each('/ans/a')    {      
      |answer|
        result << Answer.new(answer.text, answer.attributes['correct'])
    }
    result
  end
  
  def correct_answers
    result = []
    return result unless answers
    doc = REXML::Document.new answers
    i = 0
    doc.root.elements.each('/ans/a')    {      
      |answer|
      result << i if answer.attributes['correct']
      i += 1
    }
    result.join(",")
  end
  
  def collect_answers(texts, values)
    doc = REXML::Document.new '<ans/>'
    if texts and values
      for i in 0...texts.size do
        unless texts[i].empty?
          a = REXML::Element.new('a').add_text(texts[i].strip)
          a.add_attribute 'correct', 'true' if values and values.include?(i.to_s)
          doc.root.add_element a 
        end
      end
    end
    self.answers = doc.to_s
  end
  
  def add_answer
    doc = answers ? REXML::Document.new(answers) : REXML::Document.new('<ans/>')
    doc.root.add_element REXML::Element.new('a').add_text('')
    self.answers = doc.root.to_s
  end
  
  def correct_answer?(correct_answer, user_answer)
    if correct_answer && user_answer
      correct_answer.split(",").sort.eql?(user_answer.split(",").sort)
    else
      false
    end
  end

  def report(answer)
    all_answers = get_answers  
    
    correct_answer_numbers =  REXML::XPath.first(answer, "c").text.split(",")
    user_answer_text = REXML::XPath.first(answer, "u").text    
    user_answers =  user_answer_text.nil? ? [] : user_answer_text.split(",")
    
    @correct_answers_text = []
    @user_answers_text = []    
    
    correct_answer_numbers.each {|ca| @correct_answers_text << all_answers[ca.to_i].text}
    user_answers.each {|ua| @user_answers_text << all_answers[ua.to_i].text}

    question_report
  end

end