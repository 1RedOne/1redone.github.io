$FixedPostsPath = gci .\_posts | ? Extension -In ('.md',".markdown")
$FixedPostsPathBaseName = $FixedPostsPath | % { $_.Name.SubString(11) }
$PostsToProcess = gci .\_posts -Recurse | 
    ? Extension -In ('.md',".markdown") | % {
        if ( $FixedPostsPathBaseName -notcontains $_.Name `
        -and $FixedPostsPathBaseName -notcontains $_.Name.Substring(11)){
            write-host "need to fix $($_.Name)"
            $_
        }
    }

"found $($PostsToProcess.Count) files to process"
"======================================================"
$fixedPosts = get-item .\fixed
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
    #change the path of images
    #update in script
    
    $newName = "$($FixedPosts.FullName)\$($fileDate.P2.Replace('"',''))-$($file.Name)"

    Write-host -ForegroundColor Cyan "---new name determined to be `n`t`t$newName"
    #move to base dir
    set-content -Path "$newName" -Value $fileContent -Force 
    #copy to fixed
    #exit
    read-host "check the file!"
    #pause to check
}

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

#find this string ![remote-tightVNCUI](images/remote-tightvncui.png)