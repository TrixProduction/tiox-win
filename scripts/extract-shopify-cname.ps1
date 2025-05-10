param ( 
    [string]$inputFile
)

if (-not (Test-Path $inputFile)) {
    Write-Host "❌ File not found: $inputFile"
    exit
}

$baseName = [System.IO.Path]::GetFileNameWithoutExtension($inputFile)
$outputFile = "../outputs/domaine-$baseName.txt"

Select-String -Path $inputFile -Pattern "shops.myshopify.com." |
ForEach-Object {
    ($_.Line -split '\s+')[0].TrimEnd('.')
} | Sort-Object -Unique | Set-Content $outputFile

Write-Host "✅ Output file: $outputFile"
