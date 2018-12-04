Function Write-Log{
Param ($out)
  Write $out
  if (Test-Path -Path 'C:\OutMount' -PathType Container) {
    Add-Content -Path C:\OutMount\debug.txt -Value $out
  }
}

if (-not (Test-Path env:SLEEP_SECS)) { $env:SLEEP_SECS = 2 }

Write-Log "$(get-date) -- Starting SleepyEcho. Sleep interval is $env:SLEEP_SECS sec."

while ($true) {
  if (Test-Path env:EXTRAS) { $extras=" EXTRAS: $env:EXTRAS" } else {$extras=""}
  if (Test-Path env:VAULT_TOKEN) { $vt=" VAULT_TOKEN: $env:VAULT_TOKEN" } else {$vt=""}
  Write-Log "$(get-date) -- Alive... going back to sleep for $env:SLEEP_SECS seconds.$vt$extras"
  start-sleep $env:SLEEP_SECS
}