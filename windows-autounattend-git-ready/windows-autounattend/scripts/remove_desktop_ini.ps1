$targets = @(
    "$env:USERPROFILE\Desktop\desktop.ini",
    "$env:PUBLIC\Desktop\desktop.ini"
)

foreach ($target in $targets) {
    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Force
        Write-Host "Removed: $target"
    }
}

Write-Host "Done."
