$Date = get-date
Import-Module activedirectory 

$HTMLHead=@" 
<title>PAM Report</title> 
 <Head>
 <STYLE>
 BODY{background-color :#FFFFF} 
TABLE{Border-width:thin;border-style: solid;border-color:Black;border-collapse: collapse;} 
TH{border-width: 1px;padding: 1px;border-style: solid;border-color: black;background-color: ThreeDShadow} 
TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color: Transparent} 
</STYLE>
</HEAD>

"@ 
 
$DomainAdmins = Get-ADGroupMember "Domain Admins" | Get-AdUser -Property LastLogonDate | select name,distinguishedName,LastLogonDate | ConvertTo-HTML
[array]$DAUsers = (Get-ADGroupmember -Identity "Domain Admins")
$DACount = $DAUsers.count

$EnterpriseAdmins = Get-ADGroupMember "Enterprise Admins" | Get-AdUser -Property LastLogonDate | select name,distinguishedName,LastLogonDate | ConvertTo-HTML
[array]$EAUsers = (Get-ADGroupmember -Identity "Enterprise Admins")
$EACount = $EAUsers.count

$Administrators = Get-ADGroupMember "Administrators" | Get-AdUser -Property LastLogonDate | select name,distinguishedName,LastLogonDate | ConvertTo-HTML
[array]$AUsers = (Get-ADGroupmember -Identity "Administrators")
$ACount = $AUsers.count

$BackupOps = Get-ADGroupMember "Backup Operators" | Get-AdUser -Property LastLogonDate | select name,distinguishedName,LastLogonDate | ConvertTo-HTML
[array]$BOUsers = (Get-ADGroupmember -Identity "Backup Operators")
$BOCount = $BOUsers.count

$SchemaAdmins = Get-ADGroupMember "Schema Admins" | Get-AdUser -Property LastLogonDate | select name,distinguishedName,LastLogonDate | ConvertTo-HTML
[array]$SAUsers = (Get-ADGroupmember -Identity "Schema Admins")
$SACount = $SAUsers.count

#HTML Body Content
$HTMLBody = @"<CENTER>
<Font size=4><B>Privileged Access Management Report</B></font></BR>
<I>Script last run:$date</I><BR />
Objective: Show user accounts that have escalated privileges. Service Accounts should be an exception.</BR>
<B>Domain Admins</B><BR /><TABLE><TR><TD>$DomainAdmins</TD></TR></TABLE></BR>
<B>Enterprise Admins</B><BR /><TABLE><TR><TD>$EnterpriseAdmins</TD></TR></TABLE></BR>
<B>Administrators</B><BR /><TABLE><TR><TD>$Administrators</TD></TR></TABLE></BR><B>Backup Operators</B><BR />
<TABLE><TR><TD>$BackupOps</TD></TR></TABLE></BR>

<B>Schema Admins</B><BR />
<TABLE><TR><TD>$SchemaAdmins</TD></TR></TABLE></BR>
<B>Active Directory Admin Count</B><BR />
<TABLE><TR><TD>Domain Admins</TD><TD>Enterprise Admins</TD><TD>Administrators</TD><TD>Backup Operators</TD><TD>Schema Admins</TD></TR><TR><TD>$DACount</TD><TD>$EACount</TD><TD>$ACount</TD><TD>$BOCount</TD><TD>$SACount</TD></TR></TABLE></CENTER></BR>
"@
  
#Export to HTML$StatusUpdate | ConvertTo-HTML -head $HTMLHead -body $HTMLBody | out-file "C:\inetpub\wwwroot\gen\pamreport.html" -Append 

#Send an email notification
$SMTPServerName = get-content -Path "C:\inetpub\wwwroot\cfg\smtpservername.cfg"
$SMTPPort = get-content -Path "C:\inetpub\wwwroot\cfg\smtpport.cfg"
$EmailTo = get-content -Path "C:\inetpub\wwwroot\cfg\emailto.cfg"
$EmailFrom = get-content -Path "C:\inetpub\wwwroot\cfg\emailfrom.cfg"

send-mailmessage -SmtpServer $SMTPServerName -port $SMTPPort -to $EmailTo -from $EmailFrom -subject "PowerShell Automated Reports:  MS Active Directory Administrator Count"  -BodyAsHtml @"</BR><B>Active Directory Admin Count</B><BR /><TABLE><TR><TD>Domain Admins</TD><TD>Enterprise Admins</TD><TD>Administrators</TD><TD>Backup Operators</TD><TD>Schema Admins</TD></TR><TR><TD>$DACount</TD><TD>$EACount</TD><TD>$ACount</TD><TD>$BOCount</TD><TD>$SACount</TD></TR></TABLE></CENTER></BR> 
"@
