---
title: "Quick Fix : Registry key to disable Hardware Graphic acceleration for Office"
date: "2014-07-22"
redirect_from : /2014/07/22/quick-fix-registry-key-to-disable-hardware-graphic-acceleration-for-office
---

Hope this helps guys!

`reg add HKCU\\Software\\Microsoft\\Office\\15.0\\Common\\Graphics /v DisableHardwareAcceleration /t REG\_DWORD /d 0x0 /F`