require 'active_support'

module Tests
  module Config

    @@question_types = {'TestQ' => 'Тест', 'WordQ' => 'Ответ', 'SeqQ' => 'Последовательность'}
    @@enable_ip_filter = false
    @@allowed_ip = ['127.0.0.1']
    @@max_answers_size = 2048
    @@max_question_size = 4096
    @@exam_variants = {'a' => 'Тест', 'b' => 'Экзамен (1-5 баллов)', 'c' => 'Экзамен (1-10 баллов)'}
    
    mattr_accessor :question_types
    mattr_accessor :enable_ip_filter
    mattr_accessor :allowed_ip
    mattr_accessor :max_answers_size
    mattr_accessor :max_question_size
    mattr_accessor :exam_variants
    
  end
end
