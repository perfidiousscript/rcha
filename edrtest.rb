#! ruby
require "optparse"
require "open3"

outputJSON = {}

options = {}
options[:process] = false
options[:process_name] = nil
options[:create_file] = false
options[:file_path] = nil
options[:network_connection] = false
options[:address] = nil

OptionParser.new do |opts|
  opts.banner = "Usage: edrtest.rb [options]"

  opts.on("-p [process]", "--process [process]", "Run the passed process") do |p|
    options[:process] = true
    options[:process_name] = p
  end

  opts.on("-f [filepath]", "--file [filepath]", "Create, modify and delete a file at the given path") do |p|
    options[:create_file] = true
    options[:file_path] = p
  end

  opts.on("-n [address]", "--network [address]", "Open connection and transmit data to provided path") do |p|
    options[:network_connection] = true
    options[:address] = p
  end
end.parse!

p "options: #{options}"
p "ARGV[0]: #{ARGV[0]}"

pid = Process.fork do
  stdout, status = Open3.capture2('ls')
  sleep 1
end

psOut, psStatus = Open3.capture2("ps", "-p #{pid}", "-O", "lstart,ruser")

splitPSOut = psOut.to_s.split()

outputJSON["process"] = {
  id: splitPSOut[7],
  start_time: {
    day: splitPSOut[8],
    month: splitPSOut[9],
    date: splitPSOut[10],
    time: splitPSOut[11],
    year: splitPSOut[12],
  },
  username: splitPSOut[13],
  command_line: splitPSOut[18],
  #process_name: 'ls',
}

puts "output json: #{outputJSON}"

Process.wait
