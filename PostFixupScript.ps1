$i = 1
Function IsProbablyAnImage($string){
    write-host "check $string to see if a link or image..."
    if ( $string -like "*.png*" -or $string -like "*.jpg*" -or $string -like "*.gif*"){
        write-host "this looks like an image, process"
        return $true
    }
    else{
        write-host "this looks like a URL, skipping"
        return $false
    }
}
if (-not((get-location).Path  -like "*1redone.github.io")){
 throw "need to run from blogs directory"
}
#to use, place a source year into the posts directory
$FixedPostsPath = gci .\_posts | ? Extension -In ('.md',".markdown")
$FixedPostsPathBaseName = $FixedPostsPath | % { $_.Name.SubString(11) }
$PostsToProcess = gci .\_posts -Recurse | 
    ? Extension -In ('.md',".markdown") | % {
        try{if ( $FixedPostsPathBaseName -notcontains $_.Name `
        -and $FixedPostsPathBaseName -notcontains $_.Name.Substring(11)){
            write-host "need to fix [$($_.FullName)])"
            $_
        }}
        catch{"can't parse $($_.Name)"}
    }

"found $($PostsToProcess.Count) files to process"
"======================================================"
$fixedPosts = get-item .\_posts
forEach ($file in $PostsToProcess){
    Write-host -fore Yellow "Parsing file [$($file.Name)]"
    #scrape file for images
    $fileContent = gc $file.FullName
    $imagesToFix = $fileContent | select-string -pattern "\]\(.*\)" 
    #if not found => Continue
    if (0 -eq $imagesToFix.Count){"---no images"}
    #calculate new image path
    $fileDate = $fileContent | select-string "date:" |convertfrom-string
    forEach ($img in $imagesToFix){
        $elementToFix = $img.ToString().Split('(')[-1]
        if (IsProbablyAnImage $elementToFix){
            $fixedElement = "../assets/images/$($file.Directory.Parent.Name)/$($file.Directory.Name)/$elementToFix"
            "---replacing $elementToFix with `n`t`t$fixedElement"
            $fileContent = $fileContent.Replace($elementToFix,$fixedElement)
        }
        #image should look like 
        #![](../assets/images/2020/08/images/quicker-auto-mocking-in-c.png) 

    }

    #update and add redirect 
    
    $dateLine =$fileContent | select-string "date:"
    $fileContent = $fileContent.Replace('\[/caption\]','')
    $fileContent = $fileContent.Replace('\[/code\]',"`n``````").Replace("\[code lang='powershell'\]","``````powershell`n").Replace('\[code lang="powershell" light="true"\]',"``````powershell`n").Replace("\[code lang=`"powershell`"\]","``````powershell`n")
    $fileContent = $fileContent.Replace('\[code\]',"```````n")
    $redirectPayload = "/$($fileDate.P2.Replace('"','').Replace('-','/'))/$($file.BaseName)"
    $addRedirect = @"
$($dateLine.Line)
redirect_from : $redirectPayload
coverImage: ..\assets\images\foxPlaceHolder.webp
"@

    $fileContent = $fileContent -replace $dateLine.Line, $addRedirect

    
    $newName = "$($FixedPosts.FullName)\$($fileDate.P2.Replace('"',''))-$($file.Name)"

    Write-host -ForegroundColor Cyan "---new name determined to be `n`t`t$newName"
    #move to base dir
    set-content -Path "$newName" -Value $fileContent -Force 
    
    #exit
    read-host "$i of $($PostsToProcess.Count)"
    #pause to check
    $i++
}


#find this string ![remote-tightVNCUI](images/remote-tightvncui.png)