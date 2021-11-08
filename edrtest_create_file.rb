def create_file(file_path = "", file_type)
  t = Time.now.iso8601
  file_name = "#{file_path}edr_test_file_#{t}.#{file_type}"
  pid = Process.fork do
    File.new file_name, "w"
    sleep 1
  end

  fileCreateOut, psStatus = Open3.capture2("ps", "-p #{pid}", "-O", "lstart,ruser")
  full_path = File.expand_path(file_name)

  splitPSOut = fileCreateOut.to_s.split()

  create_file_data = {
    id: splitPSOut[7],
    timestamp: {
      day: splitPSOut[8],
      month: splitPSOut[9],
      date: splitPSOut[10],
      time: splitPSOut[11],
      year: splitPSOut[12],
    },
    path: full_path,
    activity_type: 'create',
    username: splitPSOut[13],
    command_line: splitPSOut[18],
    process_name: splitPSOut[17],
  }

  Process.wait

  return full_path, create_file_data
end
