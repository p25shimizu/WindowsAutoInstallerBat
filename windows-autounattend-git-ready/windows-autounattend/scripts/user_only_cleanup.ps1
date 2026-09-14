$ErrorActionPreference = 'Stop'

Write-Host '=== User-only cleanup ==='

$user = Get-LocalUser -Name 'user' -ErrorAction SilentlyContinue
if (-not $user) {
    throw 'Local account "user" does not exist.'
}

# Add user to the built-in Administrators group by SID, avoiding localization issues.
$admins = Get-LocalGroup -SID 'S-1-5-32-544'
$members = Get-LocalGroupMember -SID $admins.SID -ErrorAction SilentlyContinue

if ($members.Name -notcontains "$env:COMPUTERNAME\user") {
    Add-LocalGroupMember -SID $admins.SID -Member 'user'
    Write-Host 'Added "user" to Administrators.'
} else {
    Write-Host '"user" is already an administrator.'
}

# Remove only the extra account created by the old unattended setup.
# Built-in Administrator (RID -500) is intentionally preserved.
$extra = Get-LocalUser -Name 'Admin' -ErrorAction SilentlyContinue
if ($extra) {
    if ($extra.SID.Value -match '-500$') {
        Write-Warning '"Admin" resolves to the built-in Administrator account, so it was NOT deleted.'
    } else {
        Remove-LocalUser -Name 'Admin'
        Write-Host 'Removed extra local account "Admin".'
    }
}

Write-Host ''
Write-Host 'Current local users:'
Get-LocalUser | Select-Object Name, Enabled, SID | Format-Table -AutoSize
