---
title: "How to query your Azure Devops Pipelines, using PowerShell"
date: "2024-05-08"
redirect_from : 2024/05/08/How-to-query-your-Azure-Devops-Pipelines-using-PowerShell
coverImage: /assets/images/2024/SiftingTheDigitalRapids.webp
categories: 
  - "scripting"
tags: 

 - "azuredevops" 
 - "devops" 
 - "pipelines"
excerpt: "In the digital realm of Azure DevOps, where pipelines flow as endlessly as the rivers of the fabled Babylon, we find ourselves in need of a divine intervention."
fileName: '2024-05-08-how-to-query-your-azure-devops-pipelines-using-powershell'
---
In the digital realm of Azure DevOps, where pipelines flow as endlessly as the rivers of the fabled Babylon, we find ourselves in need of a divine intervention.



![Header for this post, reads 'How To Make GitHub Button'](/assets/images/2024/SiftingTheDigitalRapids.webp)


![Header for this post, reads 'How To Make GitHub Button'](\assets\images\2021\trackingStates.webp)



How to query your Azure Devops Pipelines, using PowerShell

In the digital realm of Azure DevOps, where pipelines flow as endlessly as the rivers of the fabled Babylon, we find ourselves in need of a divine intervention. 

Enter PowerShell, the Lord’s own programming language, ready to smite the overwhelming chaos of untracked appIDs and rogue variable values.

```powershell
# Arm yourself with the holy script
$AzureDevOpsPat = "p@ssw0rd" # Replace with your Personal Access Token


$headers = @{
     'Authorization' = 'Bearer ' + $AzureDevOpsPat
 }

$OrganizationName = "Heavenly-DevOps" # Replace with your Azure DevOps Organization Name
$ProjectName = "Creation"             # Replace with your Azure DevOps Project Name
$FolderToSearch = "42"                # The folder containign the pipelines we seek

#the variables which may contain the fields we seek
$VariablesToList = "ServicePrincipalUserName","service-principal-id"

$link = "https://dev.azure.com/{0}/{1}/_apis/pipelines?api-version=7.2-preview.1" `
    -f $OrganizationName, $ProjectName

if ($data -eq $null){
      $data = Invoke-RestMethod -Method 'GET' -Uri $link -Headers $headers
   }
   else{
      "keeping last result"
}

$folderPipelines = $data.value | where folder -eq $FolderToSearch

foreach($a in $folderPipelines){
    $values = $null
    $thisPipeline = Invoke-RestMethod -Method 'GET' -Uri $a.url -Headers $headers
     
    foreach($field in $VariablesToList){
        $values += $thisPipeline.configuration.variables.$field.value
    }
    
    @{name=$thisPipeline.Name;SPId=[string]::Join(',', $values)}  
}
```


### Why, you ask, would one embark on such a celestial quest? 

Imagine, if you will, sifting through thousands of Azure DevOps Pipelines, each a potential Pandora’s box, just to see if any dare to use a particular appID or variable value. 

It’s like finding a needle in a haystack, but fear not! With PowerShell, you’re not just any farmer looking at hay pieces by hand; instead, you’re a shepherd with a divine rod, parting the sea of data with ease and precision.

So, don your robes, grab your staff, and prepare to command the elements of Azure DevOps with the omnipotence of PowerShell. 

For in this quest, it is not just about finding what is lost, but about mastering the cosmos of continuous integration and delivery.

### Special Thanks

This post was inspired by work begun by Marc Fellman on his blog post https://www.codit.eu/blog/using-powershell-to-query-azure-devops/