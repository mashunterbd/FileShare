#!/bin/bash

# Define the list of required tools
required_tools=(zip wget npm python3 qrcode-terminal server)

# Function to check and install missing tools
check_and_install_tools() {
    for tool in "${required_tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            echo "$tool is not installed. Installing..."
            case $tool in
                zip)
                    sudo apt-get install -y zip || { echo "Failed to install $tool"; exit 1; }
                    ;;
                wget)
                    sudo apt-get install -y wget || { echo "Failed to install $tool"; exit 1; }
                    ;;
                npm)
                    sudo apt-get install -y npm || { echo "Failed to install $tool"; exit 1; }
                    ;;
                python3)
                    sudo apt-get install -y python3 || { echo "Failed to install $tool"; exit 1; }
                    ;;
                qrcode-terminal)
                    npm install -g qrcode-terminal || { echo "Failed to install $tool"; exit 1; }
                    ;;
                server)
                    wget https://raw.githubusercontent.com/mashunterbd/HTTP-Server/main/install.sh
                    chmod +x install.sh
                    ./install.sh || { echo "Failed to install $tool"; exit 1; }
                    ;;
                *)
                    echo "Unknown tool $tool"
                    exit 1
                    ;;
            esac
        else
            echo "$tool is already installed. Skipping installation."
        fi
    done
    echo "All requirements fulfilled."
}

# Function to display help message
show_help() {
    echo "Usage: share [options]"
    echo "Options:"
    echo "  share -on            Share all files in the current directory"
    echo "  share -off           Stop sharing and delete index.html and test.zip"
    echo "  share -off -r        Stop sharing and delete all files in the current directory"
    echo "  share -on-en         Share file with encrypted password"
    echo "  share --help         Display this help message"
}

# Function to start sharing files
start_sharing() {
    # Zip all files in the current directory into test.zip
    zip test.zip *

    # Create index.html file
    cat <<EOL > index.html
<!DOCTYPE html>
<html>
<head>
  <title>File Download</title>
</head>
<body onload="downloadFile()">
  <script>
    function downloadFile() {
      var link = document.createElement('a');
      link.href = '/test.zip';
      link.download = 'test.zip';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  </script>
</body>
</html>
EOL

    # Stop server if already started previously
    server -stop

    # Run server
    server -start

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
}

# Function to start sharing files with encryption
start_sharing_encrypted() {
    # Ask user for password
    echo -e "\e[32mChoose your zip password:\e[0m"
    read -s password

    # Zip all files in the current directory into test.zip with password
    zip -e -P "$password" test.zip *

    # Create index.html file
    cat <<EOL > index.html
<!DOCTYPE html>
<html>
<head>
  <title>File Download</title>
</head>
<body onload="downloadFile()">
  <script>
    function downloadFile() {
      var link = document.createElement('a');
      link.href = '/test.zip';
      link.download = 'test.zip';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  </script>
</body>
</html>
EOL

    # Stop server if already started previously
    server -stop

    # Run server
    server -start

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
}

# Function to stop sharing files
stop_sharing() {
    # Delete the test.zip and index.html files
    rm -f test.zip index.html
    # Stop the server
    server -stop
}

# Function to stop sharing and delete all files in the current directory
stop_sharing_and_delete_all() {
    echo "Do you really want to delete all files in this directory? (yes/no)"
    read confirmation
    if [ "$confirmation" == "yes" ]; then
        rm -f *
        stop_sharing
    else
        echo "Operation cancelled."
    fi
}

# Main script logic
if [ "$1" == "--help" ]; then
    show_help
elif [ "$1" == "-on" ]; then
    check_and_install_tools
    start_sharing
elif [ "$1" == "-on-en" ]; then
    check_and_install_tools
    start_sharing_encrypted
elif [ "$1" == "-off" ]; then
    if [ "$2" == "-r" ]; then
        stop_sharing_and_delete_all
    else
        stop_sharing
    fi
else
    echo "Invalid option. Use --help for usage information."
fi
