require 'date'
class StatisticReport
  def initialize(attributes)
    @start_date = attributes['start_date']  ? Date.parse(attributes['start_date'].split(".").reverse.join(".")) : Date.today
    @finish_date = attributes['finish_date']  ? Date.parse(attributes['finish_date'].split(".").reverse.join(".")) : Date.today    
  end

  def start_date
    @start_date ? @start_date.strftime("%d.%m.%Y") : Date.today.strftime("%d.%m.%Y")
  end
  
  def finish_date
    @finish_date ? @finish_date.strftime("%d.%m.%Y") : Date.today.strftime("%d.%m.%Y")
  end

end