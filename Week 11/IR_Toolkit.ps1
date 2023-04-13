# Storyline: Create an Incident Response Toolkit


# User specifies directory in which they want to save the output
$myDir = Read-Host -Prompt "Which directory would you like to save the output to?"

# Function to output csv files and hashes to a directory
function save_output ($results, $filename) {

# Add file name onto the directory that the user specified
$path = "$myDir\$filename"

# Export results to a CSV
$results | Export-CSV -NoTypeInformation `
-path $path

# Get a hash of the file and add that hash to a txt file
Get-FileHash $path | Add-Content "$myDir\hashes.txt"

}


# Running Processes and path for each process
$processes = Get-Process | Select-Object -Property Id, ProcessName, Path

# Call function save_output
save_output $processes "processes.csv"

# All registered services and the path to the executable controlling the service
$services = Get-WmiObject win32_service | select Name, State, PathName


# Call function save_output
save_output $services "services.csv"

# All TCP network sockets
$sockets = Get-NetTCPConnection | select-object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess

# Call function save_output
save_output $sockets "sockets.csv"

# All user account information
$accountInfo = Get-WmiObject -Class Win32_UserAccount | select-object Name, SID, AccountType, LocalAccount, PasswordChangeable, Status

# Call function save_output
save_output $accountInfo "accountInfo.csv"

# All NetworkAdaptherConfiguration Information
$adapterInfo = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | foreach-object {
$_ | select-object `
      @{Name="ServiceName";      Expression={$_.ServiceName}},
      @{Name="MACAddress";       Expression={$_.MACAddress}},
      @{Name="IPAddress";        Expression={$_.IPAddress[0]}},
      @{Name="DHCPServer";       Expression={$_.DHCPServer}},
      @{Name="DefaultIPGateway"; Expression={$_.DefaultIPGateway[0]}}
}

# Call function save_output
save_output $adapterInfo "adapterInfo.csv"

# 4 Other artifacts that would be useful #

#1 All installed software - To check to see what specific software is installed make sure nothing is suspicious
$installedSoftware = Get-WmiObject -ClassName Win32_Product | select-object Name, Version, Vendor, InstallDate, InstallSource, PackageName, LocalPackage

# Call function save_output
save_output $installedSoftware "installedSoftware.csv"

#2 Security event logs - To check information on what is occurring on system
$securityEvents = Get-EventLog -LogName Security -Newest 50 | select Timegenerated, InstanceID, Source, Message

# Call function save_output
save_output $securityEvents "securityEvents.csv"

#3 Inbound firewall rules - check to see what type of firewall rules are being used and cross reference with security logs
$firewall = Get-NetFirewallRule | where-object {$_.Direction -eq "inbound"} | select Name, DisplayName, Profile, Action, EdgeTraversalPolicy, Description, DisplayGroup, StatusCode

# Call function save_output
save_output $firewall "firewall.csv"

#4 Commandline history - to give info on previous users activity
$history = Get-History | select Id, CommandLine, ExecutionStatus, StartExecutionTime, EndExecutionTime

# Call function save_output
save_output $history "history.csv"


# Zip the directory into a file called results.zip
Compress-Archive -LiteralPath $myDir -DestinationPath "C:\Users\derek.bouvia\Desktop\results.zip"

# Get a hash of the resulting zip file
Get-FileHash "C:\Users\derek.bouvia\Desktop\results.zip" | Add-Content "C:\Users\derek.bouvia\Desktop\ZipResults_checksum.txt"

