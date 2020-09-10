
$Date= Get-date     
Import-Module activedirectory 
 
$HTMLHead=@" 
<title>GPO Replication</title> 
 <Head>
 <STYLE>
 BODY{background-color :#FFFFF} 
TABLE{Border-width:thin;border-style: solid;border-color:Black;border-collapse: collapse;} 
TH{border-width: 1px;padding: 1px;border-style: solid;border-color: black;background-color: ThreeDShadow} 
TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color: Transparent} 
</STYLE>
</HEAD>

"@ 
 
$GPRep = repadmin /replsummary


#HTML Body Content
$HTMLBody = @"<CENTER>
<Font size=4><B>Group Policy Objects Replication Report</B></font></BR>
<I>Script last run:$date</I><BR />
Objective: Show current Group Policy Replication in Active Directory</BR>
<B>Grou Policy Objects Replication</B><BR /><TABLE><TR><TD>$GPRep</TD></TR></TABLE></BR>
</CENTER>
"@
  
#Export to HTML$StatusUpdate | ConvertTo-HTML -head $HTMLHead -body $HTMLBody | out-file "C:\inetpub\wwwroot\gen\gprepreport.html" -Append 


