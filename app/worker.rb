require_relative "./connection.rb"

class Worker
  attr_reader :con

  def initialize(queue_name, queue_options = {})
    @con = Connection.new(queue_name: queue_name, queue_options: queue_options)
  end

  def listen_to_default_exchange
    puts " [*] Waiting for messages. To exit press CTRL+C"

    con.queue.subscribe(block: true) do |_delivery_info, _properties, body|
      puts " [x] Received #{body}"
    end
  rescue Interrupt => _
    con.close

    exit(0)
  end

  def listen_to_persistent_queue
    puts " [*] Waiting for messages. To exit press CTRL+C"

    # worker only grabs new task when finished processing, can distribute load better
    con.channel.prefetch(1)

    con.queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
      puts " [x] Received #{body}"
      sleep body.count(".").to_i
      puts " [x] Done"

      # send ack that message was received && processed
      con.channel.ack(delivery_info.delivery_tag)
    end
  rescue Interrupt => _
    con.close

    exit(0)
  end

  def pubsub
  end
end

# w1 = Worker.new("hello")
# w1.listen_to_default_exchange

# w2 = Worker.new("persistent_queue", durable: true)
# w2.listen_to_persistent_queue

w3 = Worker.new("fan1")
w3.pubsub
