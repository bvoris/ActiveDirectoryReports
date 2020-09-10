

#Run the DCDiag - Warning, this can take a long time depending on your AD!
dcdiag.exe /s:DOMAINNAME.com /test:dns /dnsdelegation /v /e /x:"C:\inetpub\wwwroot\gen\dcdiag.xml" /e

#Now pull the XML output into an object and start manipulating it
[System.Xml.XmlDocument] $XD = new-object System.Xml.XmlDocument
$XD.Load("C:\inetpub\wwwroot\gen\dcdiag.xml")

#Loop through all the domain controllers and get the results of the test - tests are dynamically added to 
#the object
$Result = ForEach ($Element in $XD.DCDIAGTestResults.DNSEnterpriseTestResults.Summary.Domain.DC)
{   $Tests = New-Object PSObject -Property @{
        DC = $Element.Name
    }
    $Fields = @("DC")
    ForEach ($Test in $Element.Test)
    {   Add-Member -InputObject $Tests -MemberType NoteProperty -Name $Test.Name -Value $Test.Status
        $Fields += $Test.Name
    }
    $Tests
}

$dated = (Get-Date -format F)
#HTML Header for report
$htmlhead = @"
<HEAD>
<TITLE>Administrator Report</TITLE>
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #FEF7D6;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #D9E3EA;}
</style>
</HEAD>
"@

#HTML Body for report
$htmlbody = @"

<CENTER>
<Font size=5><B>DNS Health Report</B></font></BR>
<Font size=4><B>DNS Health Report</B></font></BR>
<Font size=3>$dated<BR />
<I>Purpose:</I> This report designed to run DCDiag.exe and report any problems in DNS.<BR /><BR />
</CENTER></font><BR />
"@

$fileDate = get-date -uformat %Y-%m-%d

#Create the HTML and save it to a file
$HTML = $Result | Select $Fields | ConvertTo-Html -Head $htmlhead  -PreContent $htmlbody
$HTML | Out-File "C:\inetpub\wwwroot\gen\dnshealthreport.html"

