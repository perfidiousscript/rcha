#! ruby
require "optparse"
require "open3"
require "json"
require "fileutils"
require "time"
require "net/http"
require_relative "edrtest_process.rb"
require_relative "edrtest_network.rb"
require_relative "edrtest_create_file.rb"
require_relative "edrtest_modify_file.rb"
require_relative "edrtest_delete_file.rb"

outputJSON = {}
options = {}
file_name = ""
options[:process] = false
options[:process_name] = nil
options[:create_file] = false
options[:file_path] = nil
options[:network_connection] = false
options[:address] = nil

OptionParser.new do |opts|
  opts.banner = "Usage: edrtest.rb [options]"

  opts.on("-a", "--all", "Use defaults to run a process, create/modify/delete file and make network call") do |p|
    options[:process] = true
    options[:create_file] = true
    options[:file_path] = ''
    options[:file_type] = 'txt'
    options[:network_connection] = true
    options[:address] = "127.0.0.1"
  end

  opts.on("-p [process name]", "--process [process name]", "Run the passed process, default to 'ls'") do |p|
    options[:process] = true
    options[:process_name] = p
  end

  opts.on("-f [relative filepath],[filetype]", "--file [relative filepath],[filetype]", Array, "Create, modify and delete a file at the given relative file path") do |p|
    options[:create_file] = true
    options[:file_path] = p[0] || ''
    options[:file_type] = p[1] || 'txt'
  end

  opts.on("-n [address]", "--network", "Open connection and transmit data") do |p|
    options[:network_connection] = true
  end
end.parse!

if options[:process]
  outputJSON[:process] = run_process(options[:process_name])
end

if options[:create_file]
  file_name, create_data = create_file(options[:file_path], options[:file_type])
  modify_data = modify_file(file_name)
  delete_data = delete_file(file_name)
  outputJSON[:create_file] = create_data
  outputJSON[:modify_file] = modify_data
  outputJSON[:delete_file] = delete_data
end

if options[:network_connection]
  outputJSON[:network] = network_connection()
end

t = Time.now.iso8601
file_name = "edr_test_output_#{t}.txt"
File.open(file_name, mode="w"){|f| f.write(JSON.pretty_generate(outputJSON))}
