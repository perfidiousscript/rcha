def modify_file(file_path)
  t = Time.now.iso8601
  pid = Process.fork do
    File.open(file_path, "w") {|f| f.write "File modified at #{t}"}
    sleep 1
  end

  fileModifyOut, psStatus = Open3.capture2("ps", "-p #{pid}", "-O", "lstart,ruser")


  splitPSOut = fileModifyOut.to_s.split()

  modify_file_data = {
    id: splitPSOut[7],
    timestamp: {
      day: splitPSOut[8],
      month: splitPSOut[9],
      date: splitPSOut[10],
      time: splitPSOut[11],
      year: splitPSOut[12],
    },
    path: file_path,
    activity_type: 'modify',
    username: splitPSOut[13],
    command_line: splitPSOut[18],
    process_name: 'touch',
  }

  Process.wait

  modify_file_data
end
