class Cte < ApplicationJob
  queue_as :default

  def perform(*args)
    puts Job.count
  end
end