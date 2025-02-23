# remove ms edge and revoke windows's access to the folder

$EdgePath = "C:\Program Files (x86)\Microsoft"

Remove-Item $EdgePath -Recurse -Force
New-Item -Path "C:\Program Files (x86)\" -Name "Microsoft" -ItemType "directory"
$Acl = Get-Acl $EdgePath
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM", "Write", "ContainerInherit,ObjectInherit", "None", "Deny")

$Acl.SetAccessRule($Ar)
Set-Acl $EdgePath $Acl