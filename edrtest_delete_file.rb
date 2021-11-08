def delete_file(file_path)
  pid = Process.fork do
    File.delete(file_path)
    sleep 1
  end

  fileModifyOut, psStatus = Open3.capture2("ps", "-p #{pid}", "-O", "lstart,ruser")


  splitPSOut = fileModifyOut.to_s.split()

  delete_file_data = {
    id: splitPSOut[7],
    timestamp: {
      day: splitPSOut[8],
      month: splitPSOut[9],
      date: splitPSOut[10],
      time: splitPSOut[11],
      year: splitPSOut[12],
    },
    path: file_path,
    activity_type: 'delete',
    username: splitPSOut[13],
    command_line: splitPSOut[18],
    process_name: splitPSOut[17],
  }

  Process.wait

  delete_file_data
end
