require_relative "./connection.rb"

con = Connection.new

begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  con.queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [x] Received #{body}" # -- #{delivery_info} // #{properties}"
  end
rescue Interrupt => _
  con.close

  exit(0)
end
