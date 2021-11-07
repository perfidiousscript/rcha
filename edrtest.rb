#! ruby
require "optparse"
require "open3"
require "json"
require "fileutils"
require "time"
require_relative "edrtest_process.rb"
require_relative "edrtest_network.rb"
require_relative "edrtest_file.rb"

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

  opts.on("-p [process name]", "--process [process name]", "Run the passed process") do |p|
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

if options[:process]
  outputJSON[:process] = run_process(options[:process_name])
end

if options[:create_file]
  outputJSON[:file] = create_file()
end

if options[:network_connection]
  outputJSON[:network] = network_connection()
end

t = Time.now.iso8601
file_name = "edr_test_output_#{t}.txt"
File.open(file_name, mode="w"){|f| f.write(outputJSON)}
