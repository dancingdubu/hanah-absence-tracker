$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = if ($env:PORT) { $env:PORT } else { 8767 }
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Output "Serving $root on http://localhost:$port/"

$mimeTypes = @{
  '.html' = 'text/html; charset=utf-8'
  '.css'  = 'text/css'
  '.js'   = 'application/javascript'
  '.json' = 'application/json'
  '.png'  = 'image/png'
  '.ico'  = 'image/x-icon'
}

while ($listener.IsListening) {
  $ctx  = $listener.GetContext()
  $req  = $ctx.Request
  $resp = $ctx.Response

  $path = $req.Url.LocalPath.TrimStart('/')
  if ($path -eq '') { $path = 'absence_calendar.html' }
  $file = Join-Path $root $path

  if (Test-Path $file -PathType Leaf) {
    $ext  = [System.IO.Path]::GetExtension($file)
    $mime = if ($mimeTypes[$ext]) { $mimeTypes[$ext] } else { 'application/octet-stream' }
    $bytes = [System.IO.File]::ReadAllBytes($file)
    $resp.ContentType = $mime
    $resp.ContentLength64 = $bytes.Length
    $resp.OutputStream.Write($bytes, 0, $bytes.Length)
    $resp.StatusCode = 200
  } else {
    $resp.StatusCode = 404
  }
  $resp.Close()
}
