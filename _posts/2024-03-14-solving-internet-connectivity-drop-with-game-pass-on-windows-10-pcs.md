---
title: "Solving internet connectivity drop with Game Pass on Windows 10 PCs"
date: "2024-03-14"
layout: post
redirect_from : 2024/03/14/Solving-internet-connectivity-drop-with-Game-Pass-on-Windows-10-PCs
coverImage: \assets\images\2024\SolvedNetworkFails.webp
categories:
  - "scripting"
tags:
 - "reddit"
 - "gamepass"
 - "netstat"
 - "networking"
excerpt: "Thought I'd share my findings here with this irritating problem which ended up breaking my outbound web traffic on my gaming pc, forcing me to restart regularly."
fileName: '2024-03-14-solving-internet-connectivity-drop-with-game-pass-on-windows-10-pcs'
---
Thought I'd share my findings here with this irritating problem which ended up breaking my outbound web traffic on my gaming pc, forcing me to restart regularly.

![](/assets/images/2024/SolvedNetworkFails.webp)

## Symptom

The situation is that after resuming from sleep, my gaming PC would suddenly not be able to resolve any new DNS requests nor open any new traffic / webpages.

For instance, in trying to open a page in Edge or Chrome, I'd see `ERR_NETWORK_CONNECTION`. Next, if I tried to invoke a webrequest from PowerShell to test connectivity outside of a web browser, I'd see this baffling error:

```powershell
Invoke-restmethod https://google.com

Invoke-RestMethod: An operation on a socket could not be performed because the system lacked sufficient buffer space or because a queue was full.

```

This was accompanied with these events in Event Viewer:


>A request to allocate an ephemeral port number from the global TCP port space has failed due to all such ports being in use.

And

>TCP/IP failed to establish an outgoing connection because the selected local endpoint was recently used to connect to the same remote endpoint. This error typically occurs when outgoing connections are opened and closed at a high rate, causing all available local ports to be used and forcing TCP/IP to reuse a local port for an outgoing connection. To minimize the risk of data corruption, the TCP/IP standard requires a minimum time period to elapse between successive connections from a given local endpoint to a given remote endpoint.

## What's stealing all my ports?
I ran the netstat command to see where all of my ports were going! 

You'd think Windows would have support for a bajillion ports, since Windows supports communications on ports from from 1-65535, right? Well, the first 1024 are reserved, but the other 64,511 should be plenty...right?

But then I remembered that PowerShell has some much better command alternatives than `netstat`  for Windows 10 and up, so I wrote this one-liner to get all of my ports and see which process is taking them all:

```
 Get-NetTcpConnection  | 
   Group-Object -Property OwningProcess | 
        Select Count,Name | sort Count -Descending

Count Name
----- ----
 5143 4556
    8 10664
    7 8304
    6 15284
    4 6416
    3 0
    3 4
    2 13184
```

Hmm. Most processes are using 10 or less ports but one is using more than 5000? That doesn't smell right.

I expanded the PowerShell some more, so that it would also grab the owning process as well

```
Get-NetTcpConnection  | 
  Group-Object -Property OwningProcess | 
    Select Count,Name | sort Count -Descending | 
      select -first 4 | % {
        Get-Process -PID $_.Name
        }

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
   2679   149.43     195.05      18.83    4556   2 EAConnect_microsoft
     41    36.77       8.48       0.33    8304   2 XboxGameBarWidgets
    206   362.44     432.64     141.23   15284   2 SearchApp
     26    23.93      51.54      12.83   10664   2 msedge
```

# The culprit: EA Connect
I then opened up Process Monitor and filtered to processes called `Ea*` and found that EA Connect is crashing rapidly for some reason.  The ProcMon dump lead me to file access operations which revealed the location of its log file 

Path: %localappdata%\Electronic Arts\EA Desktop\Logs\EAConnect_microsoft.log

And I saw this message, repeating in `EAConnects` log file, which perfectly matches the original message from Event Viewer


>TCP/IP failed to establish an outgoing connection because the selected local endpoint was recently used to connect to the same remote endpoint. This error typically occurs when outgoing connections are opened and closed at a high rate, causing all available local ports to be used and forcing TCP/IP to reuse a local port for an outgoing connection. To minimize the risk of data corruption, the TCP/IP standard requires a minimum time period to elapse between successive connections from a given local endpoint to a given remote endpoint.

My fix was to sign into EA Connect, which was installed along with my GamePass Subscription, and the issue never returned again.

Source for troubleshooting info: [Troubleshoot port exhaustion issues](https://learn.microsoft.com/en-us/troubleshoot/windows-client/networking/tcp-ip-port-exhaustion-troubleshooting)



### Bonus: Why did this happen?
I installed and I use GamePass. I tried to install a game via GamePass that is only available through EA, and this action installed the EA Agent.

I never carried through with making an EA account or signing into one, but the agent being installed was enough to setup the EA Background Service and the EA Connect process. From checking the logs, it looks like this is meant to check for updates for any EA Games installed and so once a second the process checks for any games installed. But it crashes due to me not having signed in.

Then a second later it checks again.

### Why would Windows let this happen?

You'd think one app using many thousands of ports would be a warning sign, and it is. 

In fact within Windows, when a process requests a port, if that port is not  used within 4 seconds, it gets recyled back into the pool of available ports. 

But in this instance a network request is tried one second later. And so every second, it adds a new port to its list.

And after 64,511 attempts, my outbound ports were totally consumed my this process, and then all new connections fail, but importantly previously opened connection could continue to function.

And **that** is why I needed to restart once a day.