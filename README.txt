To Run/Help/show all flags:
'$ ./edrtest.rb -h'


For the assignment I wrote a basic ruby cli.
It is called by passing 'edrtest.rb' and then flags for the desired action.
Allowed flags, the arguments each takes, and what each flag does can be found by passing -h.
Conceptually I broke it down into three parts: run process, create/modify/destroy a file, make a network call.

The script parses the options, then sets the options hash depending on passed flags and arguments.
Since the actual processes being run and files being used by the script don't seem to be particularly important I allowed
the user to pass arguments, but set defaults for everything if they didn't care.

I wasn't sure the best way to get the command line and process name from the process call so I did this somewhat roundabout
dance of forking the process, causing the forked process to sleep (so the forked process didn't immediately end) then
calling 'ps <PID of forked process>'. There seems to be a native way to get these things in ruby, but this worked and didn't seem to have
any immediately apparent downsides, so I just went with it. The network call is a little different.

File creation/modification/deletion is pretty straightforward, and it uses Ruby's native file utils to do each of these things.
It works when a relative file path is passed, but errors when an absolute path is passed. Was unable to figure out exactly why this was,
but seemed like something that could be fixed with a little more time.

The network call is similarly simple, using Ruby's UPDsocket library. I chose UDPSocket only because
I had never used it before and it seemed pretty bare bones. It opens two UDP sockets on the machine and sends
a little data (27 bytes) from one socket to the other. I guess the source socket port is picked at random, so it changes each time.

Once all the calls have run it packages all the data up into JSON and writes it to 'edr_test_output_<date_time>.txt'

I tend to lean away from over-engineering and toward iteration. This implementation is admittedly barebones, but in a
real setting I'd probably show this off, get seem feedback and adjust accordingly. There is no error handling and the allowed
arguments are fairly minimal. Since the current spec doesn't mention these I didn't include them, though I would
add them in in later iterations.

json format should look something like (or some subset of) this depending on flags passed.
 {
   process: {
     start_time: XXYYZZ,
     username: 'sammoss',
     process_name: 'ls',
     command_line: '/example',
     id: '4567'
   },
   create_file: {
     timestamp: XXYYZZ,
     path: '/path/to/file',
     activity_type: 'create',
     username: 'sammoss',
     process_name: 'touch',
     command_line: 'example',
     id: '4567'
   },
   modify_file: {
     timestamp: XXYYZZ,
     path: '/path/to/file',
     activity_type: 'modify',
     username: 'sammoss',
     process_name: 'touch',
     command_line: 'example',
     id: '4567'
   },
   delete_file: {
     timestamp: XXYYZZ,
     path: '/path/to/file',
     activity_type: 'delete',
     username: 'sammoss',
     process_name: 'rm',
     command_line: 'example',
     id: '4567'
   },
   network_connection: {
     timestamp: XXYYZZ,
     username: 'sammoss',
     destination:{
       port: 8080,
       address: '56.0.4.32'
     },
     source:{
       port: 3000,
       address: '127.0.0.1'
     },
     data_amount: '10b',
     protocol: 'http',
     path: '/path/to/file',
     activity_type: 'delete',
     process_name: 'touch',
     command_line: 'example',
     id: '4567'
   }
 }
