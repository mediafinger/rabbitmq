require_relative "./connection.rb"

class Publisher
  attr_reader :con

  def initialize(queue_name, queue_options = {})
    @con = Connection.new(queue_name: queue_name, queue_options: queue_options)
  end

  def publish_to_default_exchange
    con.channel.default_exchange.publish("Hello World!", routing_key: con.queue.name)
    puts "[x] Sent 'Hello World!'"
    con.close
  end

  def create_task(message)
    con.queue.publish(message, persistent: true)
    puts " [x] Sent #{message}"

    sleep 1.0
    con.close
  end

  def pubsub(message)
    con.close # not needed here

    fanout = Fanout.new("logs")

    fanout.exchange.publish(message)
    puts " [x] Sent #{message}"

    fanout.close
  end
end

# pub_1 = Publisher.new("hello")
# pub_1.publish_to_default_exchange

# pub_2 = Publisher.new("persistent_queue", durable: true)
# message = ARGV.empty? ? "Hello World!" : ARGV.join(" ")
# pub_2.create_task(message)

pub_3 = Publisher.new()
message  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")
pub_3.pubsub(message)
