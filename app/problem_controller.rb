class ProblemController < UIViewController
  extend IB
  attr_accessor :problem

  outlet :app_name
  outlet :last_notice_at
  outlet :message
  outlet :notices_count
  outlet :where

  def viewDidLoad
    self.app_name.text = "#{problem['app_name']} (#{problem['environment']})"
    self.notices_count.text = "#{problem['notices_count']}"
    date_formatter = NSDateFormatter.alloc.init
    date_formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    date = date_formatter.dateFromString problem['last_notice_at']
    notice_time = date.strftime("%Y/%m/%d %H:%M:%S")
    self.last_notice_at.text = "Last notice: #{notice_time}"
    self.message.text = problem['message']
    self.message.resizeToFit
    self.where.text = problem['where']
  end
end
