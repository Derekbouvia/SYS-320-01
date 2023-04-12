# Task: Write a program that can start and stop the Windows Calculator only using Powershell 
# and using only the process name for the Windows calculator (to start and stop it)


Start-Process calculator:

# Wait 5 seconds

Start-Sleep 5

# Stop the calculator using the process name

Stop-Process -Name CalculatorApp
