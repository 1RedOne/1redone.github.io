function Add-FoxDeployToolToBlog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,

        [Parameter()]
        [string]$FlavorText,

        [Parameter()]
        [switch]$Force
    )

    $resolvedProject = Resolve-Path -Path $Project -ErrorAction Stop

    if (-not (Test-Path -Path $resolvedProject -PathType Container)) {
        throw "Project must be an existing directory: $Project"
    }

    $projectName = Split-Path -Path $resolvedProject -Leaf

    if ([string]::IsNullOrWhiteSpace($FlavorText)) {
        $FlavorText = $projectName
    }

    $repoRoot = $PSScriptRoot
    if ([string]::IsNullOrWhiteSpace($repoRoot)) {
        $repoRoot = (Get-Location).Path
    }

    $navigationPath = Join-Path -Path $repoRoot -ChildPath "_data\navigation.yml"
    $postsPath = Join-Path -Path $repoRoot -ChildPath "_posts"

    if (-not (Test-Path -Path $navigationPath -PathType Leaf)) {
        throw "Could not find navigation file at: $navigationPath"
    }

    if (-not (Test-Path -Path $postsPath -PathType Container)) {
        throw "Could not find posts folder at: $postsPath"
    }

    $yesterday = (Get-Date).AddDays(-1)
    $postDate = $yesterday.ToString("yyyy-MM-dd")
    $year = $yesterday.ToString("yyyy")

    $slugProject = ($projectName -replace "[^a-zA-Z0-9]+", "-").Trim("-")
    $slugProject = $slugProject.ToLowerInvariant()

    $postFileName = "{0}-new-tool-released-{1}.md" -f $postDate, $slugProject
    $postPath = Join-Path -Path $postsPath -ChildPath $postFileName

    if ((Test-Path -Path $postPath -PathType Leaf) -and -not $Force) {
        throw "Post already exists: $postPath. Re-run with -Force to overwrite."
    }

    $toolLink = "/$projectName/"
    $toolUrl = "https://www.foxdeploy.com/$projectName"

    $recommendedImagePath = "/assets/images/$year/$slugProject-hero.png"
    Write-Host "Header/Hero image recommendation: $recommendedImagePath"
    $imagePathInput = Read-Host "Hero image path (press Enter to accept recommendation)"

    if ([string]::IsNullOrWhiteSpace($imagePathInput)) {
        $imagePathInput = $recommendedImagePath
    }

    $defaultExcerpt = "I just released $FlavorText, a new web tool available at $toolUrl."
    $postExcerpt = Read-Host "Post excerpt (press Enter to use default)"
    if ([string]::IsNullOrWhiteSpace($postExcerpt)) {
        $postExcerpt = $defaultExcerpt
    }

    $navigationLines = Get-Content -Path $navigationPath

    $functionsHeaderIndex = -1
    $functionsDropdownIndex = -1
    $seriesHeaderIndex = -1

    for ($i = 0; $i -lt $navigationLines.Count; $i++) {
        if ($navigationLines[$i] -match "^- name:\s*Functions\s*$") {
            $functionsHeaderIndex = $i
            continue
        }

        if ($functionsHeaderIndex -ge 0 -and $functionsDropdownIndex -lt 0 -and $navigationLines[$i] -match "^\s{2}dropdown:\s*$") {
            $functionsDropdownIndex = $i
            continue
        }

        if ($functionsHeaderIndex -ge 0 -and $navigationLines[$i] -match "^- name:\s*Series\b") {
            $seriesHeaderIndex = $i
            break
        }
    }

    if ($functionsHeaderIndex -lt 0 -or $functionsDropdownIndex -lt 0 -or $seriesHeaderIndex -lt 0) {
        throw "Could not find the Functions dropdown block in $navigationPath"
    }

    $existingToolLinkRegex = "^\s*link:\s*" + [regex]::Escape($toolLink) + "\s*$"

    $alreadyLinked = $false
    for ($i = $functionsDropdownIndex + 1; $i -lt $seriesHeaderIndex; $i++) {
        if ($navigationLines[$i] -match $existingToolLinkRegex) {
            $alreadyLinked = $true
            break
        }
    }

    if (-not $alreadyLinked) {
        $insertLines = @(
            "    - name : $FlavorText",
            "      link: $toolLink"
        )

        $before = @()
        if ($seriesHeaderIndex -gt 0) {
            $before = $navigationLines[0..($seriesHeaderIndex - 1)]
        }

        $after = @($navigationLines[$seriesHeaderIndex..($navigationLines.Count - 1)])

        $updatedNavigation = @()
        $updatedNavigation += $before
        $updatedNavigation += $insertLines
        $updatedNavigation += $after

        Set-Content -Path $navigationPath -Value $updatedNavigation -Encoding utf8NoBOM
    }

    $postTitle = "New Tool - $FlavorText"
    $redirectPath = "/new-tool-released-$slugProject"

    $postContent = @"
---
title: "$postTitle"
date: "$postDate"
redirect_from: $redirectPath
coverImage: $imagePathInput
categories:
  - "programming"
  - "tools"
tags:
  - "$projectName"
  - "Tooling"
excerpt: "$postExcerpt"
fileName: '$postFileName'
---

![]($imagePathInput)

## Introducing $FlavorText

I just shipped a new tool: **[$FlavorText]($toolUrl)**.

### What it does

- TODO: Describe the problem this solves.
- TODO: Explain your favorite feature.
- TODO: Mention who this is for.

### How to use it

- Open **[$FlavorText]($toolUrl)**
- TODO: Add quick start steps.

### Notes

- TODO: Add implementation details, screenshots, and any known limitations.
"@

    if ((Test-Path -Path $postPath -PathType Leaf) -and $Force) {
        Remove-Item -Path $postPath -Force
    }

    Set-Content -Path $postPath -Value $postContent -Encoding utf8NoBOM

    Start-Process -FilePath "notepad.exe" -ArgumentList @($postPath)

    [pscustomobject]@{
        ProjectName = $projectName
        NavigationDisplayName = $FlavorText
        ToolUrl = $toolUrl
        NavigationUpdated = (-not $alreadyLinked)
        PostPath = $postPath
        HeroImagePath = $imagePathInput
    }
}
