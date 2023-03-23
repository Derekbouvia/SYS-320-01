# Storyline: Review the Security Event Log

# Directory to save files:
$myDir = "C:\Users\derek\Desktop\"

# List all the available Windows Event logs
Get-EventLog -list

# Create a prompt to allow user to select the Log to view
$readLog = Read-host -Prompt "Please select a log to review from the list above"

# Create a prompt that allows the user to specify a keyword or phrase to search on.
$findMessage = Read-Host -Prompt "Enter a keyword or phrase to search for"

# File name
$fileName

# Print the results for the log
Get-EventLog -LogName $readlog -Newest 40 | where {$_.Message -ilike "*$findMessage*" } | export-csv -NoTypeInformation `
-Path "$myDir\securityLogs.csv"
