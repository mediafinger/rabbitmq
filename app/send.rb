require_relative "./connection.rb"

con = Connection.new

con.channel.default_exchange.publish("Hello World!", routing_key: con.queue.name)

puts "[x] Sent 'Hello World!'"

# close the connection
con.close
