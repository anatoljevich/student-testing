class FillQuestions < ActiveRecord::Migration
  def self.up
#    Question.destroy_all
#    informatika = Discipline.find_by_name('Информатика')
#    organization = Discipline.find_by_name('Организация труда')
#   Question.create({:name => 'Операция If..Else', 
#      :discipline_id => informatika.id, 
#      :author_id => 1,
#      :text => 'Операция If..Else используется для',
#      :answers => '<ans><a>Для организации циклов</a><a correct="true">Для проверки условий</a><a>Для выхода из подпрограммы</a></ans>'
#    })
#    Question.create({:name => 'Задел', 
#      :discipline_id => organization.id, 
#      :author_id => 1,
#      :text => 'Что такое задел',
#      :answers => '<ans><a>Не знаю</a><a>Затрудняюсь ответить</a><a correct="true">То, что заделали</a></ans>'
 #   })
    
  end

  def self.down
  end
end
