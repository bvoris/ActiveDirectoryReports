﻿
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
$HTMLBody = @"
<Font size=4><B>Group Policy Objects Replication Report</B></font></BR>
<I>Script last run:$date</I><BR />
Objective: Show current Group Policy Replication in Active Directory</BR>

</CENTER>
"@
  
#Export to HTML

