if ($args.Count -gt 0) {
    $date = (Get-Date).ToString("yyyy-MM-dd")
    
    $title = $args -join " "

    $filename = $title -replace "[_ ]", "-"
    
    while ($filename -match "--") {
        $filename = $filename.Replace("--", "-")
    }

    $filename = $filename.ToLower()

    $content = Get-Content "./_posts/_template.md"

    $content = $content -replace "{title}", $title

    Set-Content "./_posts/${date}-${filename}.md" -Value $content


    Write-Host "./_posts/${date}-${filename}.md created"
    # Write-Host $content 
}
else {
    throw "You need to pass the name of the new post."
}
