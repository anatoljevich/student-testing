class StatTopicReport < StatisticReport

  attr_reader :group_id
  attr_reader :discipline_id
  
  def initialize(attributes = nil)
    @group_id = attributes['group_id'] ? attributes['group_id'].to_i : 0
    @discipline_id = attributes['discipline_id'] ? attributes['discipline_id'].to_i : 0
    super attributes
  end
  
  def by_topics
    group_condition = @group_id != 0 ? "(group_id = #{@group_id}) AND " : ""
    exam_entities = ExamEntity.find(:all, :conditions => ["#{group_condition} (DATE(finished_at) BETWEEN  ? AND ?)", @start_date, @finish_date] ).collect {|ent| ent.id}
    
    conditions = []
    if exam_entities.size > 0
      conditions[0] = "exam_entity_id IN (#{exam_entities.join(',')})"  
    else
      return []
    end
   
    if @discipline_id != 0
      disc = Discipline.find_by_id @discipline_id
      if disc && disc.topics.size > 0 
        topics_id = disc.topics.collect {|t| t.id}
        conditions[1] = "topic_id IN (#{topics_id.join(',')})"
      end
    end

    conditions.compact!
    condition = "WHERE #{conditions.join(' AND ') }"
   
#    ExamEntity.find_by_sql "SELECT id, name, correct, total, ROUND(correct*100/total) AS answer_percent, success_count, total_count, ROUND(success_count*100/total_count) AS total_percent FROM topics JOIN ( SELECT topic_id, sum(correct) AS correct, sum(total) AS total, sum(success) AS success_count, count(*) AS total_count FROM exam_entity_results #{condition} GROUP BY topic_id) AS t2 ON t2.topic_id = topics.id ORDER BY total_percent DESC"
    ExamEntity.find_by_sql "SELECT id, name, success_topics, total_topics, percent, average_percent FROM topics AS t1 JOIN (SELECT topic_id, ROUND(success_topics*100/total_topics) AS percent, success_topics, total_topics, ROUND(average*100) AS average_percent FROM (SELECT topic_id, sum(success::boolean::int) AS success_topics, count(*) AS total_topics, avg(correct/total) AS average FROM exam_entity_results #{condition} GROUP BY topic_id ) AS t2) as t3 ON t1.id = t3.topic_id;"
  end
  
end