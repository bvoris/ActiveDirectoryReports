﻿c:\Tools\PVEFindADUser.exe -current

$Date= Get-date     

 
$HTMLHead=@" 
<title>Active Users Report</title> 
 <Head>
 <STYLE>
 BODY{background-color :#FFFFF} 
TABLE{Border-width:thin;border-style: solid;border-color:Black;border-collapse: collapse;} 
TH{border-width: 1px;padding: 1px;border-style: solid;border-color: black;background-color: ThreeDShadow} 
TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color: Transparent} 
</STYLE>
</HEAD>

"@ 

$AUreportinfo = import-csv -path "c:\tools\report.csv" | ConvertTo-HTML

#HTML Body Content
$HTMLBody = @"
<Font size=4><B>Active Users Report</B></font></BR>
<I>Script last run:$date</I><BR />
Objective: Show active users on any machines</BR>

</CENTER>
"@
  
#Export to HTML

