# https://www.rabbitmq.com/tutorials/tutorial-one-ruby.html

require "bunny"

class Connection
  attr_reader :channel, :queue, :connection

  def initialize(queue_name: "hello")
    # create connection
    @connection = Bunny.new # (hostname: "some-rabbit")
    connection.start

    # create channel
    @channel = connection.create_channel

    # declare a queue
    @queue = channel.queue(queue_name)
  end

  def close
    connection.close
  end
end