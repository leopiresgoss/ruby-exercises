require 'sidekiq'

# run bundle exec sidekiq -r ./worker.rb

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

class OurWorker
  include Sidekiq::Worker

  # don't retry excepttions/erros
  # if it exceeds the retry limit, the job will go to "dead"
  sidekiq_options retry: 0

  def perform(complexity)
    case complexity
    when 'super_hard'
      sleep 20
      puts 'Really super hard'
    when 'hard'
      sleep 10
      puts "That's hard"
    else
      loop do
        sleep 1
        puts 'bug!!'
      end
      puts 'Not hard at all'
    end
  end
end

# Signal Handling =>a
#  run ps ax|grep sidekiq to see the running process
# run kill -TTIN process_id to pause the process
# run kill -USR1 process_id to stop the process
# run kill -TERM process_id to stop the process after 8 times and pushed 1 job back to Redis
# when you start the process again, it will continue from the last job (buggy one)
