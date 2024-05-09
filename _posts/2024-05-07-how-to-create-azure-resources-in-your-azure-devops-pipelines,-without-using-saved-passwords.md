---
title: "How to perform actions in Azure, in your Azure Devops Pipelines, without using Saved Passwords"
date: "2024-05-07"
redirect_from : 2024/05/07/How-to-create-Azure-resources-in-your-Azure-Devops-Pipelines,-without-using-Saved-Passwords
coverImage: \assets\images\2021\usingMSIswithinganADOpipeline.webp
categories:
  - "azuredevops"
  - "adopipeline"
  - "msi"
  - "managedServiceIdentity"
tags:
 - "devops"
excerpt: "Using saved passwords in Azure Devops Pipelines is sooooo 2023.  The new hotness is using Azure Workload Id Federation.  It only took me 27 tries to get it right, and you can learn to do it form me correctly the first time. "
fileName: '2024-05-07-how-to-create-azure-resources-in-your-azure-devops-pipelines,-without-using-saved-passwords'
---
Using saved passwords in Azure Devops Pipelines is sooooo 2023.  The new hotness is using Azure Workload Id Federation.  It only took me 27 tries to get it right, and you can learn to do it form me correctly the first time.

![Header for this post, reads 'How To Make GitHub Button'](\assets\images\2024\MigratingAzureDevopPipelinesToUseMSIs.png)

---

### Post Outline

🆕 Why do I need to change anything?  An introduction to Modern Practices

🔑 Authentication Using Workload Identity Federation

📝 How to create a Service Connection

🛠️ 'How to use a Service Connection' or Wait, it doesn't do it for me?!?
nds.

## Why do I need to change anything?  An introduction to Modern Practices?

If you work at a gigantic organization, maybe the biggest company in the world, chances are you've heard of the need to move away from saved passwords.

In a world with modern authentication solutions available, including the awesome Managed Service Identity available in Azure, or whatever alternatives exist in other Clouds--I've never cared about other clouds so ~(=^‥^)ノ ~~ there's just no reason to have User names with Passwords accessible in ways they could be corrupted and reused.

Also my company was requiring me to move away from using saved passwords. Surprising how motivating that is, the requirement to do it to keep your job.

## Authentication using Workload Identity Federation

If you're like me, those words are really just a lot of words and your brain skims over it.  The real detail here is that WIF is a cool new feature that handles creating an Enterprise Application for you in Azure AZ (or Microsoft Entra if you like using the newest name for things) **and also handles assigning permissions to it as well**.  

And these new types of credentials are natively supported within your Azure Devops Pipelines!

[Link to learn more about WIF and Service Connection](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation).

## So what do I need to do to my Pipeline to make this work?  

I assumed that if we were migrating to use a locally available credential, like we get in an MSI, that we would need to call Azure Identity's local endpoint, or something similar, but no, that is not the case!

First off, you do NOT need to try and load the credential by calling the local IMDS (instance metadata endpoint,) like the outdated guides tell you to do.  But you DO need to update your tasks from the `PowerShell@2` or other commands you might be using, over to the newer native ADO Tasks which natively support a `serviceConnection` WIF credential.

> Sounds easy, right?

**WRONG!** To actually USE any of the `AzurePowerShell@*` tasks like `AzurePowerShell@5`  In your Pipeline, you need to actually install the `Az.Accounts` and `Az` PowerShell modules.  And you need to install them first, in a previous step in your pipeline!

### This actually cost me a huge amount of time as I'd assumed that the in box `AzurePowerShell@*` tasks like `AzurePowerShell@5` would setup the PowerShell module.  

## Wait, it isn't done for me?
**That's right!  The Azure tasks in Azure devops do not download the needed PowerShell modules first**, we might be living in 2024 but its on us to setup our own modules, so here is how to do that:


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

After this, the `AzurePowerShell` commands can work.  But how do you authenticate to them?

## How to create a new Azure Service Connection to allow your ADO Pipeline to create resources in Azure

This isn't too hard.  Don't be scared.  To do this we're going to take advantage of something called [Workload Identity Federation.](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation).  

To make one, browse to the same Azure Devop's Instance where your pipeline resides and click on 'Project Settings' then 'Service Connections'.  Now, make a new Service Connection and choose 'Azure Resource Manager' as your type, then chose the top option:

![enter image description here](/assets/images/2024/createServiceConnection1.png)

You'll be prompted to specify a subscription.  This is an Azure Subscription you have access to that you'd like the pipeline to be able to use.  

**This is the destination your Azure Resources will be created in.**

**Important note**: you will need Owner permissions on the target subscription.

Next, specify the rest of the fields and make special notice of the field `Service Connection Name`, this will be the value you'll have to add to your Azure PowerShell Tasks for authentication.

![enter image description here](/assets/images/2024/createServiceConnection2.png)

> in my case, I will be using the connection name `someTestConnect`

## How do I actually use the new connection

Next, update your Yaml pipeline to use one of the many [Workload Identity Federation tasks ](https://learn.microsoft.com/en-us/azure/devops/pipelines/release/troubleshoot-workload-identity?view=azure-devops#review-pipeline-tasks).

> **Important**: don't forget to first download the Az PowerShell Modules, as seen in the step above.  You **must** do this step first or else all AzurePowerShell@ steps will fail




Here's an example of me making a new resource Group using WIF authentication:

```yaml
        - task: AzurePowerShell@4
          displayName: 'Create Resource Group'
          inputs:
            ##your service connection goes here
            azureSubscription: 'someTestConnect' 
            azurePowerShellVersion: latestVersion
            targetType: 'inline'
            script: |
              $dateTime = Get-Date
              $formattedString = "FoxTest{0:MMddHHmm}" -f $dateTime
              Write-Host $formattedString
              new-azresourcegroup -location eastus $formattedString
            pwsh: true
```

*I'm using the v4 version of this command because as of this writing in May 2024, there's a known issue with Write-Output and other commands in the v5 version**

When the pipeline runs for the first time, permission application takes place.  This means you'll be granting permission.  Meaning you will at this point need ownership permission on the target subscription:

![enter image description here](/assets/images/2024/createServiceConnection3.png)

Click 'View' and then 'Permit' to grant the service connection permissions to the subscription.  


![enter image description here](/assets/images/2024/createServiceConnection3.5.png)

And then sit back, and watch your new resources get created in the portal.


![enter image description here](/assets/images/2024/createServiceConnection4.png)

## Help I'm running into an error!

Are you seeing this error?

```
Could not find the modules: 'Az.Accounts' with Version: ''. If the module was recently installed, retry after restarting the Azure Pipelines task agent.
```

If so, then you very likely forgot to setup the Azure PowerShell modules first.  This needs to be done in a `PowerShell@2` Azure Devops Task, as seen in the section above titled **Wait, it isn't done for me?**, up above.