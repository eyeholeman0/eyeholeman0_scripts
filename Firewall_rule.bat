:: For batch firewall block of all the exe files within a program's folder

for %%G in ("C:\Program Files\Adobe\Adobe Premiere Pro 2025\*.exe") do (

netsh advfirewall firewall add rule name="Folder Lock Blocked With Batchfile %%G" dir=in action=block program="%%G" enable=yes profile=any
netsh advfirewall firewall add rule name="Folder Lock Blocked With Batchfile %%G" dir=out action=block program="%%G" enable=yes profile=any

)