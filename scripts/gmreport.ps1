
$Date= Get-date     
Import-Module activedirectory 
 
$HTMLHead=@" 
<title>Group Membership Changes</title> 
 <Head>
 <STYLE>
 BODY{background-color :#FFFFF} 
TABLE{Border-width:thin;border-style: solid;border-color:Black;border-collapse: collapse;} 
TH{border-width: 1px;padding: 1px;border-style: solid;border-color: black;background-color: ThreeDShadow} 
TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color: Transparent} 
</STYLE>
</HEAD>

"@ 
 
$NewGroupMember = Get-EventLog -comp tdanet.com -LogName Security | Where-Object {$_.EventID -eq 4728} | Select Message,TimeGenerated | ConvertTo-HTML
$RemoveGroupMember = Get-EventLog -comp tdanet.com -LogName Security | Where-Object {$_.EventID -eq 4729} | Select Message,TimeGenerated | ConvertTo-HTML

#HTML Body Content
$HTMLBody = @"<CENTER>
<Font size=4><B>Group Membership Changes Report</B></font></BR>
<I>Script last run:$date</I><BR />
Objective: Show adding or removing of users to groups in Active Directory.</BR>
<B>New Group Membership</B><BR /><TABLE><TR><TD>$NewGroupMember</TD></TR></TABLE></BR>
<B>Removal from Group Membership</B><BR /><TABLE><TR><TD>$RemoveGroupMember</TD></TR></TABLE></BR>
</CENTER>
"@
  
#Export to HTML$StatusUpdate | ConvertTo-HTML -head $HTMLHead -body $HTMLBody | out-file "C:\inetpub\wwwroot\gen\gmreport.html" -Append 


#Send an email notification
$SMTPServerName = get-content -Path "C:\inetpub\wwwroot\cfg\smtpservername.cfg"
$SMTPPort = get-content -Path "C:\inetpub\wwwroot\cfg\smtpport.cfg"
$EmailTo = get-content -Path "C:\inetpub\wwwroot\cfg\emailto.cfg"
$EmailFrom = get-content -Path "C:\inetpub\wwwroot\cfg\emailfrom.cfg"

send-mailmessage -SmtpServer $SMTPServerName -port $SMTPPort -to $EmailTo -from $EmailFrom -subject "PowerShell Automated Reports: MS Active Directory Group Membership Changes Report"  -BodyAsHtml @"<CENTER><B>IF NOTHING IS PRESENT BELOW IN THE TABLES NO GROUP MEMBERSHIP CHANGES WERE DISCOVERED</B></BR><B>New Group Membership</B><BR /><TABLE><TR><TD>$NewGroupMember</TD></TR></TABLE></BR><B>Removal from Group Membership</B><BR /><TABLE><TR><TD>$RemoveGroupMember</TD></TR></TABLE></BR></CENTER>
"@

