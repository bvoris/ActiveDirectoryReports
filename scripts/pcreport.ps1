﻿
$Date= Get-date     
Import-Module activedirectory 
 
$HTMLHead=@" 
<title>Password Compliance Report</title> 
 <Head>
 <STYLE>
 BODY{background-color :#FFFFF} 
TABLE{Border-width:thin;border-style: solid;border-color:Black;border-collapse: collapse;} 
TH{border-width: 1px;padding: 1px;border-style: solid;border-color: black;background-color: ThreeDShadow} 
TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color: Transparent} 
</STYLE>
</HEAD>

"@ 
 
$passwordcompliance = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $True} –Properties “DisplayName”|
Select-Object -Property “Displayname” | ConvertTo-HTML


#HTML Body Content
$HTMLBody = @"
<Font size=4><B>Password Compliance Report</B></font></BR>
<I>Script last run:$date</I><BR />
Objective: Show user accounts that have passwords set to not expire which makes them out of compliance. Service Accounts should be an exception.</BR>

</CENTER>
"@
  
#Export to HTML

