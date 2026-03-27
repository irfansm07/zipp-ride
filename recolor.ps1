$f = 'ZippApp.jsx'
$c = Get-Content $f -Raw -Encoding UTF8
$c = $c -replace '#080810', '#CBDDE9'
$c = $c -replace '#12121a', '#EEF4F8'
$c = $c -replace '#1c1c28', '#DDEAF3'
$c = $c -replace '#2a2a3a', '#B8CEDC'
$c = $c -replace '#1a1a28', '#C4D8E6'
$c = $c -replace '#00e5a0', '#2872A1'
$c = $c -replace '#00b87a', '#1A5C8A'
$c = $c -replace '#7b5ef8', '#1D6FA4'
$c = $c -replace '#5b3fd8', '#155F8E'
$c = $c -replace '#f0f0f8', '#0D2137'
$c = $c -replace '#8888aa', '#4A6B80'
$c = $c -replace '#666688', '#5A7A8F'
$c = $c -replace '#555577', '#5A7A8F'
$c = $c -replace '#444466', '#6A90A3'
# Fix text on primary buttons (was dark text on dark bg, now dark text on Ocean Blue buttons is wrong - use white)
$c = $c -replace "color:`"#CBDDE9`"", 'color:"#fff"'
$c | Set-Content $f -Encoding UTF8 -NoNewline
Write-Host "Done"
