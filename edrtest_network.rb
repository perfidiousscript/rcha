require 'socket'
require 'etc'

def network_connection()
    t = Time.now.iso8601

    bytes_sent = 0
    network_data = {}

    destination_ip = "127.0.0.1"
    destination_port = "3001"
    u1 = UDPSocket.new
    u1.bind(destination_ip, destination_port)
    u2 = UDPSocket.new
    u2.connect(destination_ip, destination_port)
    bytes_sent = u2.send "a bunch of test information", 0
    source_information = u1.recvfrom(1000)

  network_data = {
      id: Process.pid,
      timestamp: t,
      username: ENV['USER'],
      command_line: "./edrtest.rb",
      process_name: 'ruby',
      protocol: 'UDP',
        destination:{
          port: destination_port,
          address: destination_ip
        },
        source:{
          port: source_information[1][1],
          address: source_information[1][2]
        },
        data_amount: bytes_sent,
    }

    network_data
end
