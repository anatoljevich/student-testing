# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def error_messages_for(*params)
    options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
       else
         html[key] = 'errorExplanation'
      end
    end
      header_message = ""
      error_messages = []

      objects.each {
        |object| 
        object.errors.each {
           |attr, msg| 
           error_messages << content_tag(:li, msg) 
           } 
      }

      content_tag(:div,
        content_tag(options[:header_tag] || :h2, header_message) <<
          content_tag(:p, 'Возникли ошибки при сохранении данных') <<
            content_tag(:ul, error_messages),
          html
        )
    else
    ''
    end
  end 

  def select_question_template(question)
    if question.class == TestQ
      render :partial => 'current_test_answer'
    elsif question.class == WordQ
      render :partial => 'current_word_answer'     
    elsif question.class == SeqQ
      render :partial => 'current_sequence_answer'     
    end
  end
   
  def discipline_names(exam)
    exam.examTopics.collect { |et| et.topic.discipline.name }.uniq.join(",")
  end

  def select_with_all(model_class, name, obj, field, html_options = {})
      t = [['Все', 0]]
      model_class.find(:all).each { |gi| t << [gi.send(name), gi.id] }
      select obj , field, t, {}, html_options
  end
  
  def progress_bar(percent)
    percent = percent.to_i
    if percent < 30 
      color = '#FF8888'
    elsif percent < 70
      color = '#FFFF00'
    else
      color = '#00CC00'
    end
    "<div style='width:100px;height:18px;'>
    <div style='width:#{percent}%;height:100%;background-color:#{color};'>&nbsp</div>
    <div style='position:fixed;margin-top:-16px;margin-left:35px'> #{percent}%</div>
    </div>"
  end
  
  def select_task_header(question)
    if question.class == TestQ
      "Выберите правильный вариант ответа"
    elsif question.class == WordQ
      "Впишите ответ в текстовое поле"
    elsif question.class == SeqQ
      "Выберите правильную последовательность действий"
    end
  end
  
  def select_smile(exam_entity)
    if exam_entity.exam_variant == 'a'
     if exam_entity.passed_percent >= exam_entity.exam.passing_score
      image_tag 'up_smile.gif'
     else
      image_tag 'down_smile.gif'     
      end
    elsif exam_entity.exam_variant == 'b'
      if exam_entity.score >= 3
        image_tag 'up_smile.gif'
       else
        image_tag 'down_smile.gif'     
      end
    elsif exam_entity.exam_variant == 'c'
      if exam_entity.score >= 4
        image_tag 'up_smile.gif'
       else
        image_tag 'down_smile.gif'     
      end
    end
  end

  def link_to_remote_loading(name, options = {}, html_options ={})
    options[:loading] = "show_loading()"
    options[:complete] = "hide_loading()"
    link_to_remote(name, options, html_options)
  end
  
  def form_remote_tag_loading(options = {}, &block )
    options[:loading] = "show_loading()"
    options[:complete] = "hide_loading()"
    form_remote_tag(options, &block)
  end
  
  def evaluate_result(entity)
    if entity.exam_variant == 'a' && entity.score > 0
      return true
    elsif entity.exam_variant == 'b' && entity.score >= 3 
      return true
    elsif entity.exam_variant == 'c' && entity.score >= 4
      return true
    end
    false
  end
  
  def score(entity)
    if entity.exam_variant == 'a'
      if entity.score.nil?
        return ''
      else
        return entity.score > 0 ? "Зачтено" : "Не зачтено"
      end
    elsif ['b','c'].include? entity.exam_variant
      return entity.score
    end
  end
end
