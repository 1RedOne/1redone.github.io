---
title: "Troubleshooting common problems in Azure Devops"
date: "2024-05-09"
redirect_from : 2024/05/09/Troubleshooting-common-problems-in-Azure-Devops
coverImage: /assets/images/2024/AboveAllElseThyShallDoNoChangesOnFriday.webp
categories: 
  - "programming"
  - "devops"
tags: 
 - "azuredevops" 
 - "devops" 
 - "pipelines"
excerpt: "I love orchestration and automation, believe me I do.  But there is just something about understanding the vagaries and internal inconsistencies of these products that could break a lesser System Admin or Devops guru."
fileName: '2024-05-09-troubleshooting-common-problems-in-azure-devops'
---
I love orchestration and automation, believe me I do.  But there is just something about understanding the vagaries and internal inconsistencies of these products that could break a lesser System Admin or Devops guru.

![Header for this post, reads 'How To Make GitHub Button'](../assets/images/2024/AboveAllElseThyShallDoNoChangesOnFriday.webp) 

I love orchestration and automation, believe me I do.  But there is just something about understanding the vagaries and internal inconsistencies of these products that could break a lesser System Admin or Devops guru.  

For one thing, who wants to waste fifteen minutes reading the docs when they could take two whole days figuring it out instead?!

In this short post, I'll help you solve a few small problems you might encounter trying to use Azure PowerShell commands in your Azure Devops Pipeline.


 **Topics Covered**
* Could not find the modules Az.Accounts

* ##[error] The term 'C:\__w\1\s' is not recognized as a name of a cmdlet, function

* 403 Forbidden error on using Azure PowerShell commands

* No output when running `AzurePowerShell@` commands in Azure Devops pipelines.

### If the module was recently installed, retry after restarting the Azure Pipelines task agent. ##[error]PowerShell exited with code '1'.

When you use the `AzurePowerShell` or other `Azure*` tasks in Azure Devops, you might expect that they will setup your modules for you.  This is not in fact the case.  What they *do* do for you is run `Initialize-Azure` for you before your command executes, which handles setting up your Azure credentials from your Service Connection, SPN, or MSI, and then runs `Connect-AzAccount` and `Set-AzContect`.  

This means that before you can call *any* `Azure*` commands, you should first setup your PowerShell modules manually, using this command.

```yaml
 - task: PowerShell@2
        displayName: 'Update Az.Accounts Module'
        inputs:
          targetType: 'inline'
          script: |
           Get-PackageProvider -Name NuGet -ForceBootstrap
           Install-Module -Name Az.Accounts -Verbose -Force -AllowClobber
           Uninstall-AzureRm -Verbose
```

After this, the `AzurePowerShell` commands can work.  

### The term 'C:\__w\1\s' is not recognized as a name of a cmdlet, functio

Let's say you setup your modules as above, and then go to run subsequent commands, and see this lovely error. 

```
##[error]The term 'D:\a\1\s\myPowershellFile.ps1' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
```

This occurs because the `AzurePowerShell` commands have different parameters than the plain-jane `PowerShell` task!

Specifically, you'll need to **always specify `azurePowerShellVersion` and `azureSubscription` fields**.  Fail to do this, and the default params will think you're using a script file and throw an error.

And that leads you directly into the next problem.

### No output when running an AzureDevops command

How about this!  Your command executes without an error and **nothing happens**.

For instance, you might see this

```
2024-05-10T15:59:13.3300799Z [33;1mVERBOSE: Command [Set-AzContext] succeeded.[0m
2024-05-10T15:59:14.8584021Z ##[command]Disconnect-AzAccount -Scope CurrentUser -ErrorAction Stop
```

How lovely, it finishes executing `Set-AzContext` and then immediatly runs `Disconnect-AzAccount`.  What's the deal!?

Well in a lovely turn of events, even more parameters are different in `AzurePowerShell`.  

Specifically when using an inline script you must set your `ScriptType` to `'InlineScript'`, and then provide your actual script in `Inline: |` format.  

The below example is known good and will work and save you much frustration.

```yaml
              - task: AzurePowerShell@3
                displayName: "Create Resource Group with version 3"
                inputs:
                  azureSubscription: "putYourOwnServiceConnectionNameHere"
                  azurePowerShellVersion: latestVersion
                  ScriptType: 'InlineScript'
                  Inline: |
                    $dateTime = Get-Date
                    $formattedString = "FoxTest{0:MMddHHmm}v3" -f $dateTime
                    new-azresourcegroup -location eastus $formattedString -verbose
                    Write-output $formattedString
                  pwsh: true
```

The format of this command is noticibly different from a plain `PowerShell@2` command, so if you get no output from your `AzurePowerShell` commands, be sure to check this!

### I get a 403 Forbidden

Nothing like getting all the way here, to actually running your command and then you experience an error.  

Well, remember my golden rule "Every new failure message gets you closer to success".

Actually that's my silver rule, the true golden rule is:

![1](../assets/images/2024/AboveAllElseThyShallDoNoChangesOnFriday.webp) 

Well, if you're using a Service Connection to authenticate to Azure in your pipelines(and you should be), you may have [expected from the documents that your account would automatically be granted permissions to the relevant subscription](https://learn.microsoft.com/en-us/azure/devops/pipelines/release/azure-rm-endpoint?view=azure-devops#insufficient-privileges-to-complete-the-operation).

One thing I've found to check is to ensure your Service Connection account was actually granted permission to the target subscription.  

In my case, my Azure operations were failing due to insufficient permissions, but once I manually applied Contributor permissions to my new Enterprise Application, the task completed on next operation!

![1](../assets/images/2024/newRgsCreated.png)

