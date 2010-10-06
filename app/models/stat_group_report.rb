class StatGroupReport < StatisticReport

  attr_reader :topic_id
  attr_reader :discipline_id
  
  def initialize(attributes = nil)
    @topic_id = attributes['topic_id'] ? attributes['topic_id'].to_i : 0
    @discipline_id = attributes['discipline_id'] ? attributes['discipline_id'].to_i : 0
    super attributes
  end
  
  def by_groups
    date_condition = "(DATE(finished_at) BETWEEN '" + @start_date.to_s + "' AND '" + @finish_date.to_s + "')"
    topic_condition = nil
    if @topic_id == 0
      if @discipline_id != 0
        ts = Topic.find_all_by_discipline_id @discipline_id
        if ts.size > 0 
          topic_condition = "topic_id IN (#{ts.collect{|t| t.id}.join(',')})"
        else
          # no one result
          topic_condition = "topic_id = -1"
        end
      end
    else
      topic_condition = "topic_id = #{@topic_id}"  
    end
  conditions = [date_condition, topic_condition].compact.join(" AND ")
#    exam_entities = ExamEntity.find(:all, :conditions => ["(DATE(finished_at) BETWEEN  ? AND ?)", @start_date, @finish_date] ).collect {|ent| ent.id} 
#  @discipline_id, @topic_id, exam_entities
#SELECT topic_id, correct, total, success, group_id, success_topics, total_topics, finished_at 
#FROM exam_entity_results AS t1
#JOIN exam_entities AS t2 
#ON t1.exam_entity_id = t2.id  
#WHERE topic_id = 5 
#AND (DATE(finished_at) BETWEEN '2008-11-18' AND '2008-11-18');


#SELECT name, correct, total, ROUND(correct*100/total) AS answer_percent, success_count, total_count, ROUND(success_count*100/total_count) AS total_percent
#  FROM groups AS t5 JOIN (
#    SELECT sum(correct_questions) AS correct, sum(total_questions) AS total, group_id, sum(success_topics) AS success_count, sum(total_topics) AS total_count
#      FROM (
#        SELECT sum(correct) AS correct_questions, sum(total) AS total_questions, t2.id, group_id, success_topics, total_topics, finished_at
#          FROM exam_entity_results AS t1
#          JOIN exam_entities AS t2 ON t1.exam_entity_id = t2.id
#          WHERE topic_id = 5 AND (DATE(finished_at) BETWEEN '2008-11-18' AND '2008-11-18')
#          GROUP BY group_id, id
#      ) AS t3
#    GROUP BY group_id
#  ) AS t4 ON t5.id = t4.group_id
# ORDER BY total_percent DESC ;

# PostgreSQL version of query
#SELECT (spec || number) AS name, correct, total, ROUND(correct*100/total) AS answer_percent, success_count, total_count, ROUND(success_count*100/total_count) AS total_percent
#  FROM groups AS t5 JOIN (
#    SELECT sum(correct_questions) AS correct, sum(total_questions) AS total, group_id, sum(success_topics) AS success_count, sum(total_topics) AS total_count
#      FROM (
#        SELECT sum(correct) AS correct_questions, sum(total) AS total_questions, t2.id, group_id, success_topics, total_topics, finished_at
#          FROM exam_entity_results AS t1
#          JOIN exam_entities AS t2 ON t1.exam_entity_id = t2.id
#          WHERE topic_id = 5 AND (DATE(finished_at) BETWEEN '2008-11-18' AND '2008-11-18')
#          GROUP BY group_id, t2.id, t2.success_topics, t2.total_topics, t2.finished_at
#      ) AS t3
#    GROUP BY group_id
#  ) AS t4 ON t5.id = t4.group_id
# ORDER BY total_percent DESC ;

#check finished at

  query_string = <<EOF
SELECT (spec || number) AS name, correct, total, ROUND(correct*100/total) AS answer_percent, success_count, total_count, ROUND(success_count*100/total_count) AS total_percent
FROM groups AS t5 JOIN (
  SELECT sum(correct_questions) AS correct, sum(total_questions) AS total, group_id, sum(success_topics) AS success_count, sum(total_topics) AS total_count
    FROM (
      SELECT sum(correct) AS correct_questions, sum(total) AS total_questions, t2.id, group_id, success_topics, total_topics, finished_at
        FROM exam_entity_results AS t1
        JOIN exam_entities AS t2 ON t1.exam_entity_id = t2.id
        WHERE #{conditions}
        GROUP BY group_id, t2.id, t2.success_topics, t2.total_topics, t2.finished_at
    ) AS t3
  GROUP BY group_id
) AS t4 ON t5.id = t4.group_id
ORDER BY total_percent DESC ;
EOF

    ExamEntity.find_by_sql(query_string)

  end
  


end