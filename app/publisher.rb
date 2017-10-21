require_relative "./connection.rb"

con = Connection.new

# publish to default exchange
# con.channel.default_exchange.publish("Hello World!", routing_key: con.queue.name)
# puts "[x] Sent 'Hello World!'"

message = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

con.queue.publish(message, persistent: true)
puts " [x] Sent #{message}"

sleep 1.0
# close the connection
con.close
