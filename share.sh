#!/bin/bash

# Zip all files in the current directory into test.zip
zip test.zip *

# Create index.html file
echo "<!DOCTYPE html>
<html>
<head>
  <title>File Download</title>
</head>
<body onload=\"downloadFile()\">
  <script>
    function downloadFile() {
      var link = document.createElement('a');
      link.href = '/test.zip'; // Replace '.zip' with the name of your zip file
      link.download = 'test.zip'; // Replace 'your_zip_file_name.zip' with the name of your zip file
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  </script>
</body>
</html>" > index.html

# Stop server if already started previously 
server -stop

# Run server
server.start

# Function to generate QR code
generate_qr() {
    qrcode-terminal "http://${1}:80"
}

# Check if wlan0 has an IP address
if ip addr show wlan0 | grep -q "inet "; then
    wlan0_ip=$(ip addr show wlan0 | awk '/inet / {print $2}' | cut -d '/' -f1)
fi

# Check if wlan1 has an IP address
if ip addr show wlan1 | grep -q "inet "; then
    wlan1_ip=$(ip addr show wlan1 | awk '/inet / {print $2}' | cut -d '/' -f1)
fi

# Check for conditions to generate QR code
if [[ -n $wlan1_ip ]]; then
    generate_qr "$wlan1_ip"
elif [[ -n $wlan0_ip ]]; then
    generate_qr "$wlan0_ip"
fi

# Echo message after generating QR code
    echo -e "\n\e[91mIf Files downloaded then Delete the index.html file in current directory..\e[0m\n"
    
