if (-not (Test-Path env:SLEEP_SECS)) { $env:SLEEP_SECS = 2 }

"$(get-date) -- Starting SleepyEcho. Sleep interval is $env:SLEEP_SECS sec."

while ($true) { 
  if (Test-Path env:EXTRAS) { $extras=" EXTRAS: $env:EXTRAS" } else {$extras=""}
  "$(get-date) -- Alive... going back to sleep for $env:SLEEP_SECS seconds. $extras"
  start-sleep $env:SLEEP_SECS
} 
