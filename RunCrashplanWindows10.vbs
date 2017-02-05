' Script to allow user to select between connection to local and remote instance of Crashplan on Windows 10 
' Created by Adam Lawrence, alaw005@gmail.com
'
' IMPORTANT NOTE:
'
' For this script to work you need to first change permissions for file "C:\ProgramData\CrashPlan\.ui_info" to allow full control
' by local users. This is because script replaces this file based on whether remote or local access.
'
 
Const CRASHPLAN_PROGRAM_PATH = "C:\Program Files\CrashPlan\"
Const CRASHPLAN_CONFIG_PATH = "C:\ProgramData\CrashPlan\"
Const OverwriteExisting = TRUE
 
Dim strEndLine, strBullet
strEndLine = Chr(10)
strBullet = "   " & Chr(149) & " "
 
Dim WshShell, objFSO
set WshShell = WScript.CreateObject("WScript.Shell")
set objFSO = CreateObject("Scripting.FileSystemObject")
 
Dim strResponse
Dim strAuthentificationToken, strRemoteHostIPAddress
dim objTextFile
 
' Determine user action
Do
    ' Ask for user input
    strResponse = InputBox("Select your Cashplan option (1-3):" & strEndLine & _ 
            strEndLine & _
            strBullet & "1. Connect local instance " & strEndLine & _
            strBullet & "2. Connect remote instance " & strEndLine & _ 
            strBullet & "3. Configure remote connection", "Run Crashplan")  
    
    ' Process user input
    Select Case strResponse
        Case "1"
            Call fnRunLocalInstance()
            WScript.Quit                  
        Case "2"
            Call fnRunRemoteInstance()
            WScript.Quit                  
        Case "3"
           Call fnConfigureRemoteInstance()
        Case "" ' Cancel button
            WScript.Quit          
        Case Else
            Msgbox "You must enter your selection 1-3.", vbExclamation, "Invalid selection"
    End Select
     
Loop
 
Function fnRunLocalInstance()
   
    If objFSO.FileExists(CRASHPLAN_CONFIG_PATH & ".ui_info.local")  Then
        ' Load local instance of .ui_info file
        objFSO.CopyFile CRASHPLAN_CONFIG_PATH & ".ui_info.local", CRASHPLAN_CONFIG_PATH & ".ui_info", OverwriteExisting
    Else
        ' Save copy of local instance of .ui_info file if doesn't already exist
        objFSO.CopyFile CRASHPLAN_CONFIG_PATH & ".ui_info", CRASHPLAN_CONFIG_PATH & ".ui_info.local"
    End if
 
    WshShell.Run """" & CRASHPLAN_PROGRAM_PATH & "CrashPlanDesktop.exe" & """"
 
End Function
 
Function fnRunRemoteInstance()
   
    If objFSO.FileExists(CRASHPLAN_CONFIG_PATH & ".ui_info.remote")  Then
        objFSO.CopyFile CRASHPLAN_CONFIG_PATH & ".ui_info.remote", CRASHPLAN_CONFIG_PATH & ".ui_info", OverwriteExisting
        WshShell.Run """" & CRASHPLAN_PROGRAM_PATH & "CrashPlanDesktop.exe" & """"
    Else
        Msgbox "Cannot connect to remote instance. Please configure first.", vbExclamation, "Connection error"       
    End if
 
End Function
 
Function fnConfigureRemoteInstance()
 
    strAuthentificationToken = InputBox("Please enter remote host Authentication Token (eg 525b6fcd-7155-438f-9315-46b687e89810)", "Authentication Token")
    strRemoteHostIPAddress = InputBox("Please enter remote host IP Address (eg 192.168.15.104)", "Authentication Token")
 
    Set objTextFile = objFSO.CreateTextFile(CRASHPLAN_CONFIG_PATH & ".ui_info.remote", True)
    objTextFile.Write("4243," & strAuthentificationToken & "," & strRemoteHostIPAddress)
    objTextFile.Close
 
    Msgbox "Remote connection configuration ready.", vbOKOnly, "Remote configuration"
     
End Function
