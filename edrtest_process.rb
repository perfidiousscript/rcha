require "open3"

def run_process(process)

  process_name = process || "ls"

  pid = Process.fork do
    stdout, status = Open3.capture2(process_name)
    sleep 1
  end

  psOut, psStatus = Open3.capture2("ps", "-p #{pid}", "-O", "lstart,ruser")

  splitPSOut = psOut.to_s.split()

  Process.wait

  process_data = {
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
    process_name: process_name,
  }

  process_data
end
