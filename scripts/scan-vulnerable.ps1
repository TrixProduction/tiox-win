param (
    [Parameter(Mandatory = $true)]
    [string]$i,

    [Parameter(Mandatory = $true)]
    [string]$o
)

if (-not (Test-Path $i)) {
    Write-Host "[X] File not found: $i"
    exit
}

$total = 0
$batchSize = 100
$domains = New-Object System.Collections.Generic.List[string]
$buffer = New-Object System.Text.StringBuilder

if (Test-Path $o) { Clear-Content $o }

Get-Content $i | ForEach-Object {
    $domains.Add($_)
    $total++

    if ($domains.Count -eq $batchSize) {
        $joined = $domains -join "`n"
        $results = $joined | ../executables/httpx.exe -title -silent -threads 50 -ports 443,80 -timeout 3

        foreach ($line in $results) {
            if ($line -match "Domain misconfigured|Ecommerce Website and Sell Online") {
                $buffer.AppendLine($line) | Out-Null
                Write-Host $line
            }
        }

        [System.IO.File]::AppendAllText($o, $buffer.ToString())
        $buffer.Clear() | Out-Null
        Write-Host "[INFO] $batchSize domains tested (total: $total)"
        $domains.Clear()
    }
}

if ($domains.Count -gt 0) {
    $joined = $domains -join "`n"
    $results = $joined | ../executables/httpx.exe -title -silent -threads 50 -ports 443,80 -timeout 3

    foreach ($line in $results) {
        if ($line -match "Domain misconfigured|Ecommerce Website and Sell Online") {
            $buffer.AppendLine($line) | Out-Null
            Write-Host $line
        }
    }

    [System.IO.File]::AppendAllText($o, $buffer.ToString())
    Write-Host "[INFO] Remaining ${($domains.Count)} domains tested (total: $total)"
}
