require 'rexml/document'
class WordQ < Question

  def get_answers
    result = []
    return result unless answers
    doc = REXML::Document.new answers
    doc.root.elements.each('/ans/a')    {      
      |answer|
        result << Answer.new(answer.text, true)
    }
    result
  end
  
  def correct_answers
    result = []
    return result unless answers
    doc = REXML::Document.new answers
    doc.root.elements.each('/ans/a')    {      
      |answer|
      result << answer.text.downcase
    }
    result.join(",")
  end
  
  def collect_answers(texts, values)
    doc = REXML::Document.new '<ans/>'
    if texts
      for i in 0...texts.size do
        unless texts[i].empty?
          a = REXML::Element.new('a').add_text(texts[i].strip)
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
    return false unless user_answer
    result = false
    # I used 'chars' method to compare multibyte strings correctly
    correct_answer.split(",").each {
      |x|
      if x.downcase == user_answer.downcase
        return true
      end
    }
    result
  end

  def report(answer)
    @correct_answers_text =  REXML::XPath.first(answer, "c").text.split(",")
    user_answer_text = REXML::XPath.first(answer, "u").text    
    @user_answers_text =  user_answer_text.nil? ? [] : user_answer_text.split(",")
    
    question_report('Любой из:')
  end

end