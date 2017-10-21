require_relative "./connection.rb"

con = Connection.new

begin
  puts " [*] Waiting for messages. To exit press CTRL+C"

  con.queue.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
    puts " [x] Received #{body} -- #{properties}"
    sleep body.count(".").to_i
    puts " [x] Done"

    # send ack that message was received && processed
    con.channel.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  con.close

  exit(0)
end
