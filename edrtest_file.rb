def create_file(file_path = "", file_type)
  t = Time.now.iso8601
  file_name = "#{file_path}edr_test_file_#{t}.#{file_type}"
  puts "file name: #{file_name}"
  pid = Process.fork do
    File.new file_name, "w"
    sleep 1
  end

  fileCreateOut, psStatus = Open3.capture2("ps", "-p #{pid}", "-O", "lstart,ruser")

  splitPSOut = fileCreateOut.to_s.split()

  Process.wait

  p fileCreateOut

  # process_data = {
  #   id: splitPSOut[7],
  #   start_time: {
  #     day: splitPSOut[8],
  #     month: splitPSOut[9],
  #     date: splitPSOut[10],
  #     time: splitPSOut[11],
  #     year: splitPSOut[12],
  #   },
  #   username: splitPSOut[13],
  #   command_line: splitPSOut[18],
  #   process_name: process_name,
  # }
  #
  # process_data
  {works: true}
end
