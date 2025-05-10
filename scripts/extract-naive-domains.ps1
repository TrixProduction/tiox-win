param (
    [string]$inputFile
)

if (-not (Test-Path $inputFile)) {
    Write-Host "[X] File not found: $inputFile"
    exit
}

$baseName = [System.IO.Path]::GetFileNameWithoutExtension($inputFile)
$outputFile = "../outputs/domaine-$baseName.txt"

$reader = [System.IO.StreamReader]::new($inputFile)
$writer = [System.IO.StreamWriter]::new($outputFile, $false)
$seen = @{}

while (($line = $reader.ReadLine()) -ne $null) {
    $parts = $line -split '\s+'
    if ($parts.Count -gt 0) {
        $domain = $parts[0].TrimEnd('.')
        if ($domain.Length -lt 103 -and -not $seen.ContainsKey($domain)) {
            $writer.WriteLine($domain)
            $seen[$domain] = $true
        }
    }
}

$reader.Close()
$writer.Close()

Write-Host " Output file: $outputFile"
