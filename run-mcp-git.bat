@echo off
REM This next line is the critical fix. It tells Python where to find your packages.
set "PYTHONPATH=C:\Users\admin\AppData\Roaming\Python\Python313\site-packages"

REM Now we run the server, which can now find the module.
"C:\Program Files\Python313\python.exe" -u -m mcp_server_git