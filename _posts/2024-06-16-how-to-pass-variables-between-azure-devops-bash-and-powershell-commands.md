---
title: "Passing variables from PowerShell to Bash in Azure Devops"
date: "2024-06-16"
redirect_from : 2024/06/16/How-to-pass-variables-between-Azure-Devops-Bash-and-PowerShell-commands
coverImage: \assets\images\2024\assembly_line.gif
categories: 
  - "scripting"
tags: 
 - "ado" 
 - "pipelines" 
 - "tasks" 
 - "yaml"
excerpt: "Have you ever needed to do complex automation in Azure Devops?  Like retrieving a token for one service and handing it off to subsequent commands to use?  Then you might have been puzzled about the correct syntax to use.  In this post, I'll give you a working example of how the syntax should be used to hand variables between bash and PowerShell tasks in Azure Devops"
fileName: '2024-06-16-how-to-pass-variables-between-azure-devops-bash-and-powershell-commands'
---
Have you ever needed to do complex automation in Azure Devops?  Like retrieving a token for one service and handing it off to subsequent commands to use?  Then you might have been puzzled about the correct syntax to use.  In this post, I'll give you a working example of how the syntax should be used to hand variables between bash and PowerShell tasks in Azure Devops

![Header for this post, reads 'Handing off variables in ADO'](\assets\images\2024\assembly_line.gif)

*Post Outline*

* Is it even possible to do this?
* What makes it hard?
* Working example of passing variables from PowerShell to Bash Steps
* Referencing variables from previous stages

## Is it even possible to do this?

For a while, I will admit, I despaired.  The task seemed simple, use the `AzurePowerShell@4` task to retrieve an AzAccessToken using `Get-AzAccessToken`, and then hand that off to other bash commands for further consumption.

But it took **dozens** of iterations to get this to work!

## Why is this difficult?

Well, I found the hardest part of this to be noting the differences in syntax between PowerShell and Bash, specifically that bash is very sensitive to spacing.

```yaml
          - task: AzurePowerShell@5
            name: GetAzToken
            displayName: "Retrieve AzToken to authenticate to Nuget"
            inputs:
              azureSubscription: "TheNameOfYourServiceConnection"
              ScriptType: 'InlineScript'
              Inline: |                     
                $accessToken = Get-AzAccessToken | Select -Expand Token
                Write-Host "Storing Access Token for subsequent usage, truncating for privacy $($accessToken.Substring(0,8))"
                
                # Set the output variable
                
                Write-Host "##vso[task.setvariable variable=MyAccessToken;isOutput=true]$accessToken"
              azurePowerShellVersion: 'LatestVersion'
              pwsh: true        

```

With this step done, you've produced an output variable which will be automatically available to follow-up tasks within this stage.  Now, to retrieve it and use it in bash.

```yaml
          - task: Bash@3
            displayName: 'Configure Nuget file with PAT'
            inputs:
              targetType: 'inline'
              script: |                
                locKey=$(GetAzToken.MyAccessToken)

                echo "Using retrieved az Access token, truncated for privacy ${locKey:0:6}..."

                sed -i -e "s/NUGET_PAT/$locKey/g" '$(Build.SourcesDirectory)/NuGet.Config'
                cat '$(Build.SourcesDirectory)/NuGet.Config'                
```

The core piece to point out is that it's easy to reference variables.  If you commit a variable to `Output` using the syntax used in PowerShell above, it will be available to subsequent tasks.  

Simply use `Name.Variable` syntax to reference the variable.  Some have reported that you must use upper-case for this, but I have found this is not necessary. 

## Using a variable within a different stage

If you've made a variable an output variable, you can then reference it in follow-up jobs like so:

```yaml
 - job: Job2
        dependsOn:
          - Setup_PreReq #must be the name of the previous job
          
        pool:
          type: linux
        variables: AzureResourceGroupName']]
          AzAccessToken: $[dependencies.Setup_AzPolicy.outputs['GetAzToken.MyAccessToken']]
```

Now the variable will be available for even tasks in different jobs!