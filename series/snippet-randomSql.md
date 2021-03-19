---
layout: page
title: Tools | SQL Query Cheatsheet
permalink: /series/snippet-randomSql
hero_image: /assets/images/foxdeployMOUNTAINTOP_hero.webp
hero_height: is-medium
show_sidebar: true
---

## Do you love random SQL?

I am not going to touch this SQL code, but past me was very proud of it.


## Report for Computers with Chrome or Firefox

Necessary code for linked report “Computers with Firefox or Google Chrome” –> “Computers with a particular installed Product Name”

I’ve updated my method of doing this now, and the report is much simpler.

*Computers with Firefox or Chrome*
```
Select top 100
CASE WHEN CAT.NormalizedName like 'Mozilla Firefox%'
THEN SUBSTRING(CAT.NormalizedName, 0, 16)
ELSE CAT.NormalizedName
END as [Product Name],
CAT.NormalizedPublisher as [Publisher],
count(CAT.ResourceID) as [Instance Count],
'CCP00437' as [Collection ID]
from v_GS_INSTALLED_SOFTWARE_CATEGORIZED as CAT with (NOLOCK)
Where
(CAT.NormalizedName like 'Mozilla Firefox%')
OR
(CAT.NormalizedName like '%Google Chrome%') 
group by
CASE WHEN CAT.NormalizedName like 'Mozilla Firefox%'
THEN SUBSTRING(CAT.NormalizedName, 0, 16)
ELSE CAT.NormalizedName
END,
CAT.NormalizedPublisher
 
order by [Instance Count] desc
```
*Computers with a particular application*
```
select SCCM.Name0
,CAT.[ProductName0]
,CAT.[ProductVersion0]
,CAT.[Publisher0]
,CAT.[NormalizedName]</code>
 
FROM v_GS_INSTALLED_SOFTWARE_CATEGORIZED as CAT
join v_R_System as SCCM on CAT.ResourceID = SCCM.ResourceID
where CAT.[ProductName0] like '%' + @ProductName0 + '%'
order by CAT.[ProductVersion0] desc
```

# Detect SSD drive
You can use the following query in SCCM Reporting to detect if a hard drive is SSD or not.  Most harddrive manufacturers are nice enough to put the initials SSD within the drive name, which helps us as Windows and therefore WMI & SCCM do not distinguish between spinning and solid state disks at any useful place in the environment.

If your environment has SSD drives not captured here, simply add the model names to the case statement.  I’ve given examples of using both LIKE and EQUAL statements, to help you out if you’re new to SQL.

```
SELECT DISTINCT
cs.Model0 AS 'Model', sys.Name0 AS 'Machine Name',
sys.User_Name0 AS 'Last Logged on User', sys.User_Domain0 AS 'Domain',
sys.AD_Site_Name0 AS 'AD Site', ld.Name0 AS 'Drive Letter',
CASE
when vdisk.Model0 like '%SSD%' then 'Known SSD Drive'
when vdisk.Model0 = 'LITEONIT LF-64M1S' or
Vdisk.Model0 ='LITEONIT LFT-128M2S' then 'Known SSD Drive'
else vdisk.Model0 END as 'SSD Drive?',
REPLACE(CONVERT(varchar, cast(ld.Size0 AS money),1), '.00', '') as 'Total Drive Space on C: in MB',
REPLACE(CONVERT(varchar, cast((mem.TotalPhysicalMemory0 / 1024) as money),1), '.00', '') AS 'Total Ram Installed in MB'


FROM v_R_System AS sys INNER JOIN
v_GS_COMPUTER_SYSTEM AS cs ON sys.ResourceID = cs.ResourceID INNER JOIN
v_GS_LOGICAL_DISK AS ld ON sys.ResourceID = ld.ResourceID INNER JOIN
v_GS_X86_PC_MEMORY AS mem ON sys.ResourceID = mem.ResourceID INNER JOIN
v_gs_Disk as vdisk on sys.resourceid = vdisk.resourceid

WHERE (vdisk.Model0 NOT LIKE '%USB%')
AND (vdisk.Model0 NOT LIKE '%SD MEMORY%')
AND (vdisk.Model0 <> 'SMART')
AND (sys.Active0 = 1) AND (sys.Decommissioned0 = 0)
AND (sys.SMBIOS_GUID0 IS NOT NULL) AND (ld.Name0 = 'C:')
```

# SCCM Web Status Message Viewer
Below you’ll find the code used to recreate some of the functionality of the SCCM Status Message viewer, for SCCM SQL Web Reports. You will need to Create the Second Report first. Then, go to the first report and link it to the second. Column 1 should link to Site Code, while Column 2 should link to Computer Name.


```
select 'Warnings as of' as 'Alert View', DATEADD(ss,-240-(24*3600),GetDate()) as 'Time'
select com.SiteCode, com.MachineName, stat.MessageID, com.ComponentName,  count(*) as 'Warning Count'
from v_StatusMessage stat
join v_ServerComponents com on stat.SiteCode=com.SiteCode and stat.MachineName=com.MachineName and stat.Component=com.ComponentName
where Time
> DATEADD(ss,-240-(24*3600),GetDate()) and Severity='-2147483648'
group by com.SiteCode,com.MachineName,com.ComponentName,stat.MessageID
order by count(*) desc
select 'Errors as of' as 'Alert View', DATEADD(ss,-240-(24*3600),GetDate()) as 'Time'
select com.SiteCode, com.MachineName, stat.MessageID, com.ComponentName,  count(*) as 'Error Count'
from v_StatusMessage stat
join v_ServerComponents com on stat.SiteCode=com.SiteCode and stat.MachineName=com.MachineName and stat.Component=com.ComponentName
where Time > DATEADD(ss,-240-(24*3600),GetDate()) and Severity='-1073741824'
group by com.SiteCode, com.MachineName, com.ComponentName,stat.MessageID
order by count(*) desc
```
### Page 2 – SCCM Component Status Messages for a Particular
site in the last 24 hours


```
select SiteCode, MachineName, Component, Convert(VARCHAR(10),RecordID) as 'Record', MessageID,
DATEADD(ss,240,Time) as 'Time', 
CASE Severity  WHEN -1073741824 THEN '*' ELSE ' ' END as 'Error',
CASE Severity WHEN -2147483648 THEN '*' ELSE ' ' END as 'Warning',
CASE Severity  WHEN 1073741824 THEN '*' ELSE ' ' END as 'Informational'
  
from v_StatusMessage where Time > DATEADD(ss,-240-(24*3600),GetDate())
       and SiteCode = @sitecode
       and MachineName = @machname
       --and Component = @component
       and(Severity in(-2147483648,-1073741824))
order by MachineName, Time DESC
```

## Where Machine Name is in this list of names
Use this query if you have a list of names you need to perform an action on in SCCM.

```
select * from SMS_R_System where SMS_R_System.Name0 in
('Machine01','Machine02','Machine03'
)
```
Very easy!  Remember to use single quotes!

## Useful SCCM Disk Report
Recently I needed to write a custom SCCM Report in SQL Server Management Studio (SSMS) to report on hard drive info, including the computer name, user name, size, percentage free and amount of free disk space.  I hope this report saves you some time!

Also, if you’re seeing your devices listed as Null under FreeSpace0 it’s because you forgot to turn on Free Disk space collection under client settings.  Do that by following these steps!


```
SELECT DISTINCT
sys.Name0 AS 'Machine Name', cs.Model0 AS 'Model', cs.Manufacturer0 as 'Manufacturer',
sys.User_Name0 AS 'Last Logged on User', ld.Name0 AS 'Drive Letter',
  CASE
    when vdisk.Model0 like '%SSD%' then 'Known SSD Drive' + vdisk.Model0
    when vdisk.Model0 = 'LITEONIT LF-64M1S' or
    Vdisk.Model0 ='LITEONIT LFT-128M2S' then 'Known SSD Drive'
    else vdisk.Model0
  END
as 'Drive Type',
  CASE
   when se.ChassisTypes0 in ('3','4','6','7','15')then 'Desktop'
   when se.ChassisTypes0 in ('8','9','10','21')then 'Laptop'
   else 'SomethingTop'
  END
as 'DeviceType',
ld.Size0 as 'Total Drive Space on C: in MB',ld.FreeSpace0 as 'Free Hard Drive Space',((ld.FreeSpace0)/(CAST (ld.Size0 as Float))) as 'Percentage'
FROM v_R_System AS sys INNER JOIN
v_GS_COMPUTER_SYSTEM AS cs ON sys.ResourceID = cs.ResourceID INNER JOIN
v_GS_LOGICAL_DISK AS ld ON sys.ResourceID = ld.ResourceID INNER JOIN
v_GS_X86_PC_MEMORY AS mem ON sys.ResourceID = mem.ResourceID INNER JOIN
v_GS_SYSTEM_ENCLOSURE as SE on sys.ResourceID = se.ResourceID inner join
v_gs_Disk as vdisk on sys.resourceid = vdisk.resourceid
WHERE (vdisk.Model0 NOT LIKE '%USB%')
AND (vdisk.Model0 NOT LIKE '%SD MEMORY%')
AND (vdisk.Model0 <> 'SMART')
AND (sys.Active0 = 1) AND (sys.Decommissioned0 = 0)
AND (sys.SMBIOS_GUID0 IS NOT NULL) AND (ld.Name0 = 'C:')
and cs.Model0 <> 'Virtual Machine'
order by Percentage desc
/*Bonus fun queries below*/
 
--select distinct Manufacturer0 from v_GS_COMPUTER_SYSTEM
--select distinct ChassisTypes0 from v_GS_SYSTEM_ENCLOSURE
--select top 40 * from v_GS_LOGICAL_DISK where DeviceID0 = 'C:'
```