if ($args.Count -gt 0) {
    $date = (Get-Date).ToString("yyyy-MM-dd")
    
    $title = $args -join " "

    $filename = $title -replace "\[|\]", ""
    $filename = $filename -replace "[_ ]", "-"
    
    while ($filename -match "--") {
        $filename = $filename.Replace("--", "-")
    }

    $filename = [uri]::EscapeDataString($filename.ToLower())

    $content = Get-Content "./_posts/_template.md"

    $content = $content -replace "{title}", $title

    Set-Content "./_posts/${date}-${filename}.md" -Value $content

    Write-Host "./_posts/${date}-${filename}.md created"
    
    code -r "./_posts/${date}-${filename}.md"
}
else {
    throw "You need to pass the name of the new post."
}
