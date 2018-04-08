# SQS requires adapter

$sqs = ::Aws::SQS::Client.new(
    region:      'us-east-1',
    credentials: Aws::Credentials.new(
        'access_key_id',
        'secret_access_key',
        )
)

class SQSAdapter
  def initialize
    @monitor = Monitor.new
  end

  def enqueue(job)
    data = {
        queue_url:    job.queue_name,
        message_body: ActiveSupport::JSON.encode(job.serialize)
    }

    order_queue = job.arguments.dig(1, :order_queue).presence

    # Support of FIFO queues
    if order_queue
      data.merge!(
          message_group_id:         order_queue,
          message_deduplication_id: [order_queue, job.arguments.dig(1, :order)].join('-')
      )
    end
    @monitor.synchronize do
      $sqs.send_message(data)
    end
  end

  def enqueue_at(job, timestamp) #:nodoc:
    raise NotImplementedError, "This queueing backend does not support scheduling jobs. To see what features are supported go to http://api.rubyonrails.org/classes/ActiveJob/QueueAdapters.html"
  end
end

ActiveJob::QueueAdapters::SqsAdapter = SQSAdapter
EurekaBot::Job.queue_adapter         = :sqs

# Rake task to listen
namespace :sqs do
  desc 'run jobs'
  task :run do
    job_class = ENV['JOB_CLASS'].constantize
    poller    = Aws::SQS::QueuePoller.new(job_class.queue_name, client: sqs)
    poller.poll(max_number_of_messages: 1, wait_time_seconds: 20) do |msg|
      job_data = ActiveSupport::JSON.decode(msg.body)
      job_class.execute job_data
    end
  end
end

#
# Bonus: AMQP adapter:
#

$bunny = begin
  bunny = Bunny.new(config['amqp'])
  bunny.start
  bunny
end

$bunny_channel = begin
  bunny.create_channel
end

class AMQPAdapter
  def initialize
    @monitor = Monitor.new
  end

  def enqueue(job) #:nodoc:
    @monitor.synchronize do
      queue_name = job.queue_name
      exchange   = $bunny_channel.default_exchange
      data       = ActiveSupport::JSON.encode(job.serialize)
      queue      = $bunny_channel.queue(queue_name, durable: true)
      exchange.publish(data, routing_key: queue.name)
    end
  end

  def enqueue_at(job, timestamp) #:nodoc:
    raise NotImplementedError, "This queueing backend does not support scheduling jobs. To see what features are supported go to http://api.rubyonrails.org/classes/ActiveJob/QueueAdapters.html"
  end
end

