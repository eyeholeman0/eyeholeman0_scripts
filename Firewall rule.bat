for %%G in ("C:\Program Files (x86)\NewSoftware's\Folder Lock\*.exe") do (

netsh advfirewall firewall add rule name="Folder Lock Blocked With Batchfile %%G" dir=in action=block program="%%G" enable=yes profile=any
netsh advfirewall firewall add rule name="Folder Lock Blocked With Batchfile %%G" dir=out action=block program="%%G" enable=yes profile=any

)