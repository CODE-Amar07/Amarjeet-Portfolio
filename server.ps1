param(
    [int]$Port = 3000
)

$listener = [System.Net.Sockets.TcpListener]::Create($Port)
$listener.Start()
Write-Output "Static HTTP Server started at: http://localhost:$Port/"

$baseDir = $PSScriptRoot

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        $client.ReceiveTimeout = 4000
        $client.SendTimeout = 6000
        try {
            $stream = $client.GetStream()
            $buffer = New-Object byte[] 8192
            $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
            if ($bytesRead -gt 0) {
                $requestText = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead)
                $firstLine = $requestText.Split("`r`n")[0]
                $parts = $firstLine.Split(" ")
                if ($parts.Length -ge 2) {
                    $method = $parts[0].ToUpper()
                    $rawUrl = $parts[1].Split("?")[0]
                    $decodedUrl = [System.Uri]::UnescapeDataString($rawUrl)
                    if ($decodedUrl -eq "/" -or $decodedUrl -eq "") {
                        $decodedUrl = "/index.html"
                    }
                    $relPath = $decodedUrl.TrimStart("/").Replace("/", [System.IO.Path]::DirectorySeparatorChar)
                    $filePath = [System.IO.Path]::Combine($baseDir, $relPath)

                    if ([System.IO.File]::Exists($filePath)) {
                        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
                        $contentType = switch ($ext) {
                            ".html" { "text/html; charset=utf-8" }
                            ".css"  { "text/css; charset=utf-8" }
                            ".js"   { "application/javascript; charset=utf-8" }
                            ".png"  { "image/png" }
                            ".jpg"  { "image/jpeg" }
                            ".jpeg" { "image/jpeg" }
                            ".svg"  { "image/svg+xml" }
                            ".json" { "application/json" }
                            default { "application/octet-stream" }
                        }

                        $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
                        $header = "HTTP/1.1 200 OK`r`n" +
                                  "Content-Type: $contentType`r`n" +
                                  "Content-Length: $($fileBytes.Length)`r`n" +
                                  "Cache-Control: public, max-age=86400`r`n" +
                                  "Access-Control-Allow-Origin: *`r`n" +
                                  "Connection: close`r`n`r`n"
                        $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
                        $stream.Write($headerBytes, 0, $headerBytes.Length)
                        if ($method -ne "HEAD") {
                            $stream.Write($fileBytes, 0, $fileBytes.Length)
                        }
                        $stream.Flush()
                    } else {
                        $body = "<html><body><h1>404 Not Found</h1><p>$decodedUrl</p></body></html>"
                        $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)
                        $header = "HTTP/1.1 404 Not Found`r`n" +
                                  "Content-Type: text/html; charset=utf-8`r`n" +
                                  "Content-Length: $($bodyBytes.Length)`r`n" +
                                  "Connection: close`r`n`r`n"
                        $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
                        $stream.Write($headerBytes, 0, $headerBytes.Length)
                        if ($method -ne "HEAD") {
                            $stream.Write($bodyBytes, 0, $bodyBytes.Length)
                        }
                        $stream.Flush()
                    }
                }
            }
        } catch {
        } finally {
            $client.Close()
        }
    }
} finally {
    $listener.Stop()
}
