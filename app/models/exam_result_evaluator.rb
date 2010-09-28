class ExamResultEvaluator
  def self.score(entity)
    calculate_average(entity)
    if entity.exam_variant == 'a'
      #simple test
      entity.score = (entity.passed_percent >= entity.exam.passing_score) ? 1 : 0
    elsif entity.exam_variant == 'b'
      #exam 1-5 balls
      if !all_important_topics_passed(entity)
        entity.score = 2  
      elsif entity.average < entity.exam.passing_score
        entity.score = 2
      else
        positive_percent = calculate_positive_percent(entity)
        if positive_percent >= 75
          entity.score = 5
        elsif positive_percent >= 40
          entity.score = 4
        else
          entity.score = 3
        end
      end

    elsif entity.exam_variant == 'c'
      #exam 1-10 balls
      if !all_important_topics_passed(entity)
        entity.score = 3  
      elsif entity.average < entity.exam.passing_score
        entity.score = 3
      else
        positive_percent = calculate_positive_percent(entity)          
        if positive_percent >= 90
          entity.score = 10
        elsif positive_percent >= 80
          entity.score = 9
        elsif positive_percent >= 65
          entity.score = 8
        elsif positive_percent >= 50
          entity.score = 7
        elsif positive_percent >= 35
          entity.score = 6
        elsif positive_percent >= 20
          entity.score = 5
        else
          entity.score = 4
        end
      end
    end
  end
  
  protected
  def self.calculate_average(entity)
    #calculate average
    average = 0
    entity.examEntityResults.each {
      |res|
      average += (res.correct*100.to_f/res.total)/entity.examEntityResults.size
    }
    entity.average = average.round
  end
  
  def self.calculate_positive_percent(entity)
    positive_range = 100 - entity.exam.passing_score
    positive_exceed = entity.average - entity.exam.passing_score
    positive_exceed * 100 / positive_range
  end
  
  def self.all_important_topics_passed(entity)
    r = true
    entity.exam.examTopics.each {
      |etopic|
      if etopic.important
        res = entity.examEntityResults.find(:first, :conditions => [" topic_id = ? ", etopic.topic_id ])
        if etopic.passing_score > res.percent  
          res.update_attribute :important_fail, true
          r = false 
        end
      end
    }
    r
  end
  
end