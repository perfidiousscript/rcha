


json format
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
