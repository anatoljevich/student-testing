require 'rexml/document'
class SeqQ < Question

  def get_answers
    result = []
    return result unless answers
    doc = REXML::Document.new answers
    doc.root.elements.each('/ans/a')    {      
      |answer|
        result << Answer.new(answer.text, answer.attributes['num'])
    }
    result
  end
  
  def correct_answers
    result = []
    return result unless answers
    doc = REXML::Document.new answers
    doc.root.elements.each('/ans/a')    {      
      |answer|
      if answer.attributes['num']
        result << answer.attributes['num']
      else
        result << 0
      end
    }
    result.join(",")
  end
  
  def collect_answers(texts, values)
    doc = REXML::Document.new '<ans/>'
    if texts and values
      for i in 0...texts.size do
        unless texts[i].empty?
          a = REXML::Element.new('a').add_text(texts[i].strip)
          if values && values[i]
            a.add_attribute 'num', values[i]
          end
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
    correct_answer == user_answer 
  end
  
  def report(answer)
    @correct_answers_text = []
    @user_answers_text = []
    all_answers = get_answers  

    correct_answer_numbers =  REXML::XPath.first(answer, "c").text.split(",")
    user_answer_text = REXML::XPath.first(answer, "u").text    
    user_answers =  user_answer_text.nil? ? [] : user_answer_text.split(",")

    correct_answer_numbers.each_index {
      |i|
      a = all_answers[i]
      b = user_answers[i]

      if a && a.value && a.value.to_i != 0
        @correct_answers_text << "#{a.value}) #{a.text}"
      end
      if a && b.to_i != 0 
        @user_answers_text << "#{b}) #{a.text}"
      end
    }
    @correct_answers_text.sort!
    @user_answers_text.sort!
    
#    user_hash = Hash.new        
#    user_answers.each { |u| user_hash[u]= all_answers[u.to_i-1].text  if u.to_i > 0 }
#    @user_answers_text = user_hash.sort.each { |a| a.delete_at 0}.flatten
    
    question_report
  end

end