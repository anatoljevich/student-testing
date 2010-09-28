class StatQuestionReport < StatisticReport

  attr_reader :group_id
  attr_reader :exam_id
  
  def initialize(attributes = nil)
    @group_id = attributes['group_id'] ? attributes['group_id'].to_i : 0
    @exam_id = attributes['exam_id'] ? attributes['exam_id'].to_i : 0
    super attributes
  end
  
  def by_questions
    group_condition = @group_id != 0 ? "(group_id = #{@group_id}) AND " : ""
    exam_entities = ExamEntity.find(:all, :conditions => ["#{group_condition} (DATE(finished_at) BETWEEN  ? AND ?)", @start_date, @finish_date] )
    
    analyze_questions(exam_entities)
    
#    conditions = []
#    if exam_entities.size > 0
#      conditions[0] = "exam_entity_id IN (#{exam_entities.join(',')})"  
#    else
#      return []
#    end
   
#    if @discipline_id != 0
#      disc = Discipline.find_by_id @discipline_id
#      if disc && disc.topics.size > 0 
#        topics_id = disc.topics.collect {|t| t.id}
#        conditions[1] = "topic_id IN (#{topics_id.join(',')})"
#      end
#    end
#
#    conditions.compact!
#    condition = "WHERE #{conditions.join(' AND ') }"
#   
#    ExamEntity.find_by_sql "SELECT id, name, correct, total, ROUND(correct*100/total) AS answer_percent, success_count, total_count, ROUND(success_count*100/total_count) AS total_percent FROM topics JOIN ( SELECT topic_id, sum(correct) AS correct, sum(total) AS total, sum(success) AS success_count, count(*) AS total_count FROM exam_entity_results #{condition} GROUP BY topic_id) AS t2 ON t2.topic_id = topics.id ORDER BY total_percent DESC"
  end
  
  protected
  
  def analyze_questions(exam_entities)
    result = Hash.new
    exam_entities.each {
      |ee|
      doc = REXML::Document.new ee.result
      doc.root.elements.each('/res/q')    {
        |answer|
        unless result.has_key? answer.attributes['id'].to_i
          ques = Question.find_by_id answer.attributes['id']
          result[answer.attributes['id'].to_i] = [ques.name, 0 ,0, 0] 
        end
        if answer.attributes['correct']
          result[answer.attributes['id'].to_i][1] += 1 # success answers count
        else
          result[answer.attributes['id'].to_i][2] += 1 # fail answers count       
        end
      }
    }
    result.each_value { 
      |v| 
      v[3] = (v[1]*100/(v[1] + v[2])).round
    }
    result.sort { |a,b| a[1][3] <=> b[1][3] } 
  end
  
end