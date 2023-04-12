# Use the Get-WMI cmdlet 
#Get-WmiObject -Class Win32_service | select Name, PathName, ProcessId

#Get-WmiObject -list | where { $_.Name -ilike "Win32_[n-o]*" } | Sort-Object

#Get-WmiObject -Class Win32_account | Get-Member

#task: Grab the network adapter information using the wmi class


Get-WmiObject -Class Win32_NetworkAdapter

# Get the IP address, default gateway, and the DNS Servers
# Bonus: Get the DHCP server.
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Select-Object IPAddress, DefaultIPGateway, DNSDomain, DHCPServer
 
# Running your code using a screen recorder
