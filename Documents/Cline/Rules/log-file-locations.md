## Brief overview

This guideline specifies the location of terminal log files for future
reference.

## Log File Locations

- **Terminal Logs:** All terminal output log files are located in
  `C:\temp\term-logs`. Files are named `ConEmu-YYYY-MM-DD-pPID.log`, where `PID`
  is the process ID of the terminal.

## Log File Management

- **Size Limit:** Do not read terminal log files larger than 100KB. If a file
  exceeds this size and is attempted to be read, warn the user about it.
- **Empty After Read:** After reading any terminal log file, its content should
  be completely emptied.
- **Terminal Mapping:** Remember which file holds what kind of terminal data. If
  you don't know where the data is, check all files once to determine the
  relevant terminal, then prioritize that terminal's log file for future
  searches.
- **Fetching Logs:** You can execute commands in the terminal to help fetch log
  files.

## Terminal names

read this file: C:\Users\admin\Documents\Cline\MCP\open-terms.env to get
terminal pids.

pricemice-backend-ps - this terminal you can read if project we are working on
is C:\Projects\pricemice_python\cijene-api-clone and I ask you to read terminal.
pricemice-backend-server this terminal you can read if project we are working on
is C:\Projects\pricemice_python\cijene-api-clone and I ask you to read server
terminal.

Notice distinction read terminal or read SERVER terminal.

Note: "check terminal" and "check server terminal" can be used interchangeably
with "read terminal" and "read server terminal" respectively.

pricemice-mobile-react-server - this terminal you can read if project we are
working on is C:\Projects\pricemice_python\PriceMiceApp and I ask you to read
server terminal. This log file also contains JavaScript console logs from the
React Native application. pricemice-mobile-freeterm - this terminal you can read
if project we are working on is C:\Projects\pricemice_python\PriceMiceApp and I
ask you to read terminal.
