#!/bin/bash

# Define the list of required tools
required_tools=(zip wget npm python3 qrcode-terminal ffmpeg php exiftool)

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
                ffmpeg)
                    sudo apt-get install -y ffmpeg || { echo "Failed to install $tool"; exit 1; }
                    ;;
                php)
                    sudo apt-get install -y php || { echo "Failed to install $tool"; exit 1; }
                    ;;
                exiftool)
                    sudo apt-get install -y exiftool ||  { echo "Failed to install $tool"; exit 1; }
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
    clear
}

# Function to display help message
show_help() {
    echo "Usage: share [options]"
    echo "Options:"
    echo "  share -on            Share all files in the current directory"
    echo "  share -on-en         Share file with encrypted password"
    echo "  share -von           Share all files with visual interface"
    echo "  share -play-v        Start video streaming server"
    echo "  share -u             Start Upload Server"
    echo "  share -p             Photos Share with specify date"
    echo "  share --help         Display this help message"
}


# Function to start sharing files with visual interface
start_sharing_visual() {
    # Create HTML file
    cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File Download</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            background-color: #f9f9f9;
        }
        .file-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            width: 100%;
        }
        .file-item {
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px;
            text-align: center;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 150px;
        }
        .file-item img {
            max-width: 100px;
            max-height: 100px;
        }
        .file-item input[type="checkbox"] {
            display: block;
            margin: 10px auto;
        }
        .file-item .file-name {
            margin-top: 10px;
            font-size: 14px;
            word-wrap: break-word;
        }
        .file-item button {
            display: block;
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            font-size: 16px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .file-item button:hover {
            background-color: #218838;
        }
        .download-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            width: 100%;
        }
        .download-buttons button {
            padding: 15px 30px;
            margin: 5px;
            font-size: 18px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .download-buttons button:hover {
            background-color: #218838;
        }
    </style>
    <script>
        function downloadMarkedFiles() {
            const markedCheckboxes = document.querySelectorAll('input[name="fileCheckbox"]:checked');
            markedCheckboxes.forEach(checkbox => {
                const link = document.createElement('a');
                link.href = checkbox.value;
                link.download = checkbox.value;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            });
        }

        function downloadAllFiles() {
            const allCheckboxes = document.querySelectorAll('input[name="fileCheckbox"]');
            allCheckboxes.forEach(checkbox => {
                const link = document.createElement('a');
                link.href = checkbox.value;
                link.download = checkbox.value;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            });
        }
    </script>
</head>
<body>
    <div class="download-buttons">
        <button onclick="downloadMarkedFiles()">Only Mark File Download</button>
        <button onclick="downloadAllFiles()">All File Download</button>
    </div>
    <div class="file-container">
EOF

    # Add file items to the HTML
    for file in *; do
        if [[ -f $file ]]; then
            file_icon=""
            case "${file##*.}" in
                jpg|jpeg|png|gif)
                    file_icon="$file"
                    ;;
                mp4|avi|mov)
                    file_icon="video-icon.png"  # Placeholder icon for video files
                    ;;
                mp3|wav)
                    file_icon="audio-icon.png"  # Placeholder icon for audio files
                    ;;
                txt)
                    file_icon="txt-icon.png"  # Placeholder icon for text files
                    ;;
                pdf)
                    file_icon="pdf-icon.png"  # Placeholder icon for PDF files
                    ;;
                doc|docx)
                    file_icon="doc-icon.png"  # Placeholder icon for document files
                    ;;
                *)
                    file_icon="file-icon.png"  # Generic file icon
                    ;;
            esac

            # Generate HTML for each file
            cat <<EOF >> index.html
        <div class="file-item">
            <img src="$file_icon" alt="File">
            <input type="checkbox" name="fileCheckbox" value="$file">
            <div class="file-name">$file</div>
            <button onclick="window.location.href='$file'">Download</button>
        </div>
EOF
        fi
    done

    # Complete HTML file
    cat <<EOF >> index.html
    </div>
</body>
</html>
EOF

    # QR and PHP start script 

    # Function to clean up generated files
    cleanup() {
        echo "Cleaning up..."
        rm -f index.html
        echo "Server stopped and files cleaned up."
    }

    check_port() {
        local port=$1
        if lsof -i :$port &> /dev/null; then
            return 1 # Port is in use
        else
            return 0 # Port is available
        fi
    }

    find_available_port() {
        local port=80
        while ! check_port $port; do
            port=$((RANDOM % 65535 + 1024)) # Random port between 1024 and 65535
        done
        echo $port
    }

    generate_qr() {
        local interface_name=$1
        local ip_address=$2
        local port=$3
        if command -v qrcode-terminal &> /dev/null; then
            echo "Interface: $interface_name, IP: $ip_address, Port: $port"
            qrcode-terminal "http://${ip_address}:${port}"
        else
            echo "qrcode-terminal is not installed. Please install it using 'npm install -g qrcode-terminal'"
            exit 1
        fi
    }

    start_php_server() {
        local ip_address=$1
        local port=$2
        if command -v php &> /dev/null; then
            echo "Starting PHP server at http://${ip_address}:${port}"
            php -S "${ip_address}:${port}" &
            PHP_SERVER_PID=$!
            echo "PHP server is running with PID ${PHP_SERVER_PID}."
            echo "If you want to stop the server, press the enter button or any key."
        else
            echo "PHP is not installed. Please install PHP to run the server."
            exit 1
        fi
    }

    stop_php_server() {
        if [ -n "$PHP_SERVER_PID" ]; then
            kill $PHP_SERVER_PID
            echo "PHP server stopped."
        fi
    }

    # Check for IP addresses on all network interfaces and store interface names
    interface_info=$(ip -o -4 addr show | awk '$4 ~ /^10\.|^172\.16\.|^192\.168\./ {print $2, $4}' | cut -d/ -f1 | head -n 1)
    interface_name=$(echo $interface_info | awk '{print $1}')
    ip_address=$(echo $interface_info | awk '{print $2}')

    # Find an available port starting from 80
    port=$(find_available_port)

    if [ -n "$ip_address" ]; then
        generate_qr "$interface_name" "$ip_address" "$port"
        start_php_server "$ip_address" "$port"
    else
        echo "No IP address found for any interface. Generating QR code for localhost."
        generate_qr "localhost" "localhost" "$port"
        start_php_server "localhost" "$port"
    fi

    # Trap to handle termination, stop the PHP server, and clean up files
    trap "stop_php_server; cleanup" EXIT

    # Wait for user input to stop the server
    read -r -p "Press enter or any key to stop the server..."
    stop_php_server
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
  <a id="download-link" href="test.zip" download>Download ZIP</a>
  <script>
    function downloadFile() {
      document.getElementById("download-link").click();
    }
  </script>
</body>
</html>
EOL


# QR and php satart script 

# Function to clean up generated files
cleanup() {
    echo "Cleaning up..."
    rm -f index.html
    rm -rf test.zip
    echo "Server stopped and files cleaned up."
}

check_port() {
    local port=$1
    if lsof -i :$port &> /dev/null; then
        return 1 # Port is in use
    else
        return 0 # Port is available
    fi
}

find_available_port() {
    local port=80
    while ! check_port $port; do
        port=$((RANDOM % 65535 + 1024)) # Random port between 1024 and 65535
    done
    echo $port
}

generate_qr() {
    local interface_name=$1
    local ip_address=$2
    local port=$3
    if command -v qrcode-terminal &> /dev/null; then
        echo "Interface: $interface_name, IP: $ip_address, Port: $port"
        qrcode-terminal "http://${ip_address}:${port}"
    else
        echo "qrcode-terminal is not installed. Please install it using 'npm install -g qrcode-terminal'"
        exit 1
    fi
}

start_php_server() {
    local ip_address=$1
    local port=$2
    if command -v php &> /dev/null; then
        echo "Starting PHP server at http://${ip_address}:${port}"
        php -S "${ip_address}:${port}" &
        PHP_SERVER_PID=$!
        echo "PHP server is running with PID ${PHP_SERVER_PID}."
        echo "If you want to stop the server, press the enter button or any key."
    else
        echo "PHP is not installed. Please install PHP to run the server."
        exit 1
    fi
}

stop_php_server() {
    if [ -n "$PHP_SERVER_PID" ]; then
        kill $PHP_SERVER_PID
        echo "PHP server stopped."
    fi
}

# Check for IP addresses on all network interfaces and store interface names
interface_info=$(ip -o -4 addr show | awk '$4 ~ /^10\.|^172\.16\.|^192\.168\./ {print $2, $4}' | cut -d/ -f1 | head -n 1)
interface_name=$(echo $interface_info | awk '{print $1}')
ip_address=$(echo $interface_info | awk '{print $2}')

# Find an available port starting from 80
port=$(find_available_port)

if [ -n "$ip_address" ]; then
    generate_qr "$interface_name" "$ip_address" "$port"
    start_php_server "$ip_address" "$port"
else
    echo "No IP address found for any interface. Generating QR code for localhost."
    generate_qr "localhost" "localhost" "$port"
    start_php_server "localhost" "$port"
fi

# Trap to handle termination, stop the PHP server, and clean up files
trap "stop_php_server; cleanup" EXIT

# Wait for user input to stop the server
read -r -p "Press enter or any key to stop the server..."
stop_php_server

}

# Function to start video streaming server
start_video_streaming() {
    
# Create necessary directories if they don't exist
mkdir -p templates static styles thumbnails

# Generate thumbnails for video files
for video in *.mp4 *.mkv; do
    if [ -f "$video" ]; then
        thumbnail="thumbnails/${video%.*}.png"
        if [ ! -f "$thumbnail" ]; then
            ffmpeg -i "$video" -ss 00:00:01.000 -vframes 1 "$thumbnail"
        fi
    fi
done

# Create index.php
cat << 'EOF' > index.php
<!DOCTYPE html>
<html>
<head>
    <title>Video Streaming Server</title>
    <link rel="stylesheet" href="styles/style.css">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h1 class="my-4">Welcome to Video Streaming Server</h1>
        <div class="row">
            <?php
            $videoDir = __DIR__;
            $videos = array_diff(scandir($videoDir), array('.', '..'));
            foreach ($videos as $video) {
                $fileExtension = pathinfo($video, PATHINFO_EXTENSION);
                if (in_array($fileExtension, ['mp4', 'mkv'])) {
                    $fileSize = filesize($video);
                    $fileSizeMB = round($fileSize / (1024 * 1024), 2) . ' MB';

                    // Use ffmpeg to get video metadata (duration and resolution)
                    $output = shell_exec("ffmpeg -i \"$video\" 2>&1 | grep 'Duration\\|Video:'");
                    preg_match('/Duration: (\d+:\d+:\d+\.\d+),/', $output, $duration);
                    preg_match('/, (\d+x\d+)[,\s]/', $output, $resolution);

                    // Thumbnail path
                    $thumbnail = 'thumbnails/' . pathinfo($video, PATHINFO_FILENAME) . '.png';

                    echo '
                    <div class="col-lg-3 col-md-4 col-xs-6 thumb">
                        <div class="card mb-4 shadow-sm">
                            <a href="stream.php?file=' . urlencode($video) . '">
                                <img src="' . $thumbnail . '" class="card-img-top" alt="Play">
                            </a>
                            <div class="card-body">
                                <p class="card-text">' . $video . '</p>
                                <p class="card-text">Duration: ' . ($duration[1] ?? 'N/A') . '</p>
                                <p class="card-text">Size: ' . $fileSizeMB . '</p>
                                <p class="card-text">Resolution: ' . ($resolution[1] ?? 'N/A') . '</p>
                            </div>
                        </div>
                    </div>';
                }
            }
            ?>
        </div>
    </div>
</body>
</html>
EOF

# Create stream.php
cat << 'EOF' > stream.php
<?php
require 'VideoStream.php';

if (isset($_GET['file'])) {
    $file = $_GET['file'];
    $filePath = __DIR__ . '/' . $file;

    if (file_exists($filePath)) {
        $stream = new VideoStream($filePath);
        $stream->start();
    } else {
        echo "File not found!";
    }
} else {
    echo "No file specified!";
}
?>
EOF

# Create VideoStream.php
cat << 'EOF' > VideoStream.php
<?php
class VideoStream
{
    private $path = "";
    private $stream = "";
    private $buffer = 102400;
    private $start  = -1;
    private $end    = -1;
    private $size   = 0;

    function __construct($filePath)
    {
        $this->path = $filePath;
    }

    private function open()
    {
        if (!($this->stream = fopen($this->path, 'rb'))) {
            die('Could not open stream for reading');
        }
    }

    private function setHeader()
    {
        ob_get_clean();
        header("Content-Type: video/mp4");
        header("Cache-Control: max-age=2592000, public");
        header("Expires: ".gmdate('D, d M Y H:i:s', time()+2592000) . ' GMT');
        header("Last-Modified: ".gmdate('D, d M Y H:i:s', @filemtime($this->path)) . ' GMT' );
        $this->start = 0;
        $this->size  = filesize($this->path);
        $this->end   = $this->size - 1;
        header("Accept-Ranges: 0-".$this->end);

        if (isset($_SERVER['HTTP_RANGE'])) {
            $c_start = $this->start;
            $c_end = $this->end;

            list(, $range) = explode('=', $_SERVER['HTTP_RANGE'], 2);
            if (strpos($range, ',') !== false) {
                header('HTTP/1.1 416 Requested Range Not Satisfiable');
                header("Content-Range: bytes $this->start-$this->end/$this->size");
                exit;
            }
            if ($range == '-') {
                $c_start = $this->size - substr($range, 1);
            } else {
                $range = explode('-', $range);
                $c_start = $range[0];
                $c_end = (isset($range[1]) && is_numeric($range[1])) ? $range[1] : $c_end;
            }
            $c_end = ($c_end > $this->end) ? $this->end : $c_end;
            if ($c_start > $c_end || $c_start > $this->size - 1 || $c_end >= $this->size) {
                header('HTTP/1.1 416 Requested Range Not Satisfiable');
                header("Content-Range: bytes $this->start-$this->end/$this->size");
                exit;
            }
            $this->start = $c_start;
            $this->end = $c_end;
            $length = $this->end - $this->start + 1;
            fseek($this->stream, $this->start);
            header('HTTP/1.1 206 Partial Content');
            header("Content-Length: ".$length);
            header("Content-Range: bytes $this->start-$this->end/".$this->size);
        } else {
            header("Content-Length: ".$this->size);
        }  
    }

    private function end()
    {
        fclose($this->stream);
        exit;
    }

    private function stream()
    {
        $i = $this->start;
        set_time_limit(0);
        while(!feof($this->stream) && $i <= $this->end) {
            $bytesToRead = $this->buffer;
            if(($i + $bytesToRead) > $this->end) {
                $bytesToRead = $this->end - $i + 1;
            }
            $data = fread($this->stream, $bytesToRead);
            echo $data;
            flush();
            $i += $bytesToRead;
        }
    }

    public function start()
    {
        $this->open();
        $this->setHeader();
        $this->stream();
        $this->end();
    }
}
?>
EOF

# Create style.css
cat << 'EOF' > styles/style.css
body {
    padding-top: 20px;
}
.card-img-top {
    width: 100%;
    height: auto;
}
EOF

# QR and php satart script 

# Function to clean up generated files
cleanup() {
    echo "Cleaning up..."
    rm -f index.php stream.php VideoStream.php
    rm -rf static templates styles thumbnails
    echo "Server stopped and files cleaned up."
}

check_port() {
    local port=$1
    if lsof -i :$port &> /dev/null; then
        return 1 # Port is in use
    else
        return 0 # Port is available
    fi
}

find_available_port() {
    local port=80
    while ! check_port $port; do
        port=$((RANDOM % 65535 + 1024)) # Random port between 1024 and 65535
    done
    echo $port
}

generate_qr() {
    local interface_name=$1
    local ip_address=$2
    local port=$3
    if command -v qrcode-terminal &> /dev/null; then
        echo "Interface: $interface_name, IP: $ip_address, Port: $port"
        qrcode-terminal "http://${ip_address}:${port}"
    else
        echo "qrcode-terminal is not installed. Please install it using 'npm install -g qrcode-terminal'"
        exit 1
    fi
}

start_php_server() {
    local ip_address=$1
    local port=$2
    if command -v php &> /dev/null; then
        echo "Starting PHP server at http://${ip_address}:${port}"
        php -S "${ip_address}:${port}" &
        PHP_SERVER_PID=$!
        echo "PHP server is running with PID ${PHP_SERVER_PID}."
        echo "If you want to stop the server, press the enter button or any key."
    else
        echo "PHP is not installed. Please install PHP to run the server."
        exit 1
    fi
}

stop_php_server() {
    if [ -n "$PHP_SERVER_PID" ]; then
        kill $PHP_SERVER_PID
        echo "PHP server stopped."
    fi
}

# Check for IP addresses on all network interfaces and store interface names
interface_info=$(ip -o -4 addr show | awk '$4 ~ /^10\.|^172\.16\.|^192\.168\./ {print $2, $4}' | cut -d/ -f1 | head -n 1)
interface_name=$(echo $interface_info | awk '{print $1}')
ip_address=$(echo $interface_info | awk '{print $2}')

# Find an available port starting from 80
port=$(find_available_port)

if [ -n "$ip_address" ]; then
    generate_qr "$interface_name" "$ip_address" "$port"
    start_php_server "$ip_address" "$port"
else
    echo "No IP address found for any interface. Generating QR code for localhost."
    generate_qr "localhost" "localhost" "$port"
    start_php_server "localhost" "$port"
fi

# Trap to handle termination, stop the PHP server, and clean up files
trap "stop_php_server; cleanup" EXIT

# Wait for user input to stop the server
read -r -p "Press enter or any key to stop the server..."
stop_php_server

}

# Start Upload Server For Multiple File
start_upload() { 
    # Function to create index.html
    create_index_html() {
        cat > index.html <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Multiple File Upload Form</title>
    <style>
        body {
            font-family: sans-serif;
            margin: 0;
            padding: 0;
        }
        form {
            width: 400px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ccc;
        }
        h1 {
            text-align: center;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 10px;
        }
        input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        input[type="submit"] {
            display: block;
            margin-top: 20px;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h1>Multiple File Upload Form</h1>
    <form action="upload.php" method="post" enctype="multipart/form-data">
        <label for="files">Select multiple files to upload:</label>
        <input type="file" name="files[]" id="files" multiple>
        <br>
        <input type="submit" value="Upload Files" name="submit">
    </form>
</body>
</html>
EOL
    }

    # Function to create upload.php
    create_upload_php() {
        cat > upload.php <<EOL
<style>
.success-message {
  color: green;
  font-size: 40px;
  font-weight: bold;
  border: 5px solid #000;
  padding: 10px;
  border-radius: 10px;
}
.error-message {
  color: red;
  font-size: 40px;
  font-weight: bold;
  border: 5px solid #000;
  padding: 10px;
  border-radius: 10px;
}
</style>

<?php
if (isset(\$_POST['submit'])) {
    \$upload_dir = __DIR__ . '/uploads/';  // Specify the absolute path to the 'uploads' directory

    foreach (\$_FILES['files']['name'] as \$key => \$filename) {
        if (!empty(\$filename)) {
            \$uploaded_file = \$upload_dir . basename(\$filename);
            if (move_uploaded_file(\$_FILES['files']['tmp_name'][\$key], \$uploaded_file)) {
                echo "<p class=\\"success-message\\">File uploaded successfully: " . \$filename . "</p>";
            } else {
                echo "<p class=\\"error-message\\">File upload failed: " . \$filename . "</p>";
            }
        }
    }
}
?>
EOL
    }

    # Function to clean up generated files
    cleanup() {
        echo "Cleaning up..."
        rm -f index.html upload.php
        echo "Server stopped and files cleaned up."
    }

    check_port() {
        local port=$1
        if lsof -i :$port &> /dev/null; then
            return 1 # Port is in use
        else
            return 0 # Port is available
        fi
    }

    find_available_port() {
        local port=80
        while ! check_port $port; do
            port=$((RANDOM % 65535 + 1024)) # Random port between 1024 and 65535
        done
        echo $port
    }

    generate_qr() {
        local interface_name=$1
        local ip_address=$2
        local port=$3
        if command -v qrcode-terminal &> /dev/null; then
            echo "Interface: $interface_name, IP: $ip_address, Port: $port"
            qrcode-terminal "http://${ip_address}:${port}"
        else
            echo "qrcode-terminal is not installed. Please install it using 'npm install -g qrcode-terminal'"
            exit 1
        fi
    }

    start_php_server() {
        local ip_address=$1
        local port=$2
        if command -v php &> /dev/null; then
            echo "Starting PHP server at http://${ip_address}:${port}"
            php -S "${ip_address}:${port}" &
            PHP_SERVER_PID=$!
            echo "PHP server is running with PID ${PHP_SERVER_PID}."
            echo "If you want to stop the server, press the enter button or any key."
        else
            echo "PHP is not installed. Please install PHP to run the server."
            exit 1
        fi
    }

    stop_php_server() {
        if [ -n "$PHP_SERVER_PID" ]; then
            kill $PHP_SERVER_PID
            echo "PHP server stopped."
        fi
    }

    # Ensure the 'uploads' directory exists
    if [ ! -d "uploads" ]; then
        mkdir uploads
    fi

    # Create the necessary files
    create_index_html
    create_upload_php

    # Check for IP addresses on all network interfaces and store interface names
    interface_info=$(ip -o -4 addr show | awk '$4 ~ /^10\.|^172\.16\.|^192\.168\./ {print $2, $4}' | cut -d/ -f1 | head -n 1)
    interface_name=$(echo $interface_info | awk '{print $1}')
    ip_address=$(echo $interface_info | awk '{print $2}')

    # Find an available port starting from 80
    port=$(find_available_port)

    if [ -n "$ip_address" ]; then
        generate_qr "$interface_name" "$ip_address" "$port"
        start_php_server "$ip_address" "$port"
    else
        echo "No IP address found for any interface. Generating QR code for localhost."
        generate_qr "localhost" "localhost" "$port"
        start_php_server "localhost" "$port"
    fi

    # Trap to handle termination, stop the PHP server, and clean up files
    trap "stop_php_server; cleanup" EXIT

    # Wait for user input to stop the server
    read -r -p "Press enter or any key to stop the server..."
    stop_php_server


}

# Function to share files with encryption
share_with_encryption() {
    echo "Encrypting files and sharing..."
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

# QR and php satart script 

# Function to clean up generated files
cleanup() {
    echo "Cleaning up..."
    rm -f index.html test.zip
    
    echo "Server stopped and files cleaned up."
}

check_port() {
    local port=$1
    if lsof -i :$port &> /dev/null; then
        return 1 # Port is in use
    else
        return 0 # Port is available
    fi
}

find_available_port() {
    local port=80
    while ! check_port $port; do
        port=$((RANDOM % 65535 + 1024)) # Random port between 1024 and 65535
    done
    echo $port
}

generate_qr() {
    local interface_name=$1
    local ip_address=$2
    local port=$3
    if command -v qrcode-terminal &> /dev/null; then
        echo "Interface: $interface_name, IP: $ip_address, Port: $port"
        qrcode-terminal "http://${ip_address}:${port}"
    else
        echo "qrcode-terminal is not installed. Please install it using 'npm install -g qrcode-terminal'"
        exit 1
    fi
}

start_php_server() {
    local ip_address=$1
    local port=$2
    if command -v php &> /dev/null; then
        echo "Starting PHP server at http://${ip_address}:${port}"
        php -S "${ip_address}:${port}" &
        PHP_SERVER_PID=$!
        echo "PHP server is running with PID ${PHP_SERVER_PID}."
        echo "If you want to stop the server, press the enter button or any key."
    else
        echo "PHP is not installed. Please install PHP to run the server."
        exit 1
    fi
}

stop_php_server() {
    if [ -n "$PHP_SERVER_PID" ]; then
        kill $PHP_SERVER_PID
        echo "PHP server stopped."
    fi
}

# Check for IP addresses on all network interfaces and store interface names
interface_info=$(ip -o -4 addr show | awk '$4 ~ /^10\.|^172\.16\.|^192\.168\./ {print $2, $4}' | cut -d/ -f1 | head -n 1)
interface_name=$(echo $interface_info | awk '{print $1}')
ip_address=$(echo $interface_info | awk '{print $2}')

# Find an available port starting from 80
port=$(find_available_port)

if [ -n "$ip_address" ]; then
    generate_qr "$interface_name" "$ip_address" "$port"
    start_php_server "$ip_address" "$port"
else
    echo "No IP address found for any interface. Generating QR code for localhost."
    generate_qr "localhost" "localhost" "$port"
    start_php_server "localhost" "$port"
fi

# Trap to handle termination, stop the PHP server, and clean up files
trap "stop_php_server; cleanup" EXIT

# Wait for user input to stop the server
read -r -p "Press enter or any key to stop the server..."
stop_php_server

}


# Function to share photos
share_photos() {
    filter_type=$1

    # Function to create the HTML file with the file list based on their types
    create_html_file() {
        cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shared Photos and Videos</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            background-color: #f9f9f9;
            margin: 20px;
        }
        .file-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            width: 100%;
            margin-top: 20px;
        }
        .file-item {
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px;
            text-align: center;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 180px;
        }
        .file-item img {
            max-width: 100px;
            max-height: 100px;
        }
        .file-item input[type="checkbox"] {
            display: block;
            margin: 10px auto;
        }
        .file-item .file-name {
            margin-top: 10px;
            font-size: 14px;
            word-wrap: break-word;
        }
        .file-item button {
            display: block;
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            font-size: 16px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .file-item button:hover {
            background-color: #218838;
        }
        .download-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            width: 100%;
        }
        .download-buttons button {
            padding: 15px 30px;
            margin: 5px;
            font-size: 18px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .download-buttons button:hover {
            background-color: #0056b3;
        }
    </style>
    <script>
        function downloadMarkedFiles() {
            const markedCheckboxes = document.querySelectorAll('input[name="fileCheckbox"]:checked');
            markedCheckboxes.forEach(checkbox => {
                const link = document.createElement('a');
                link.href = checkbox.value;
                link.download = checkbox.value;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            });
        }

        function downloadAllFiles() {
            const allCheckboxes = document.querySelectorAll('input[name="fileCheckbox"]');
            allCheckboxes.forEach(checkbox => {
                const link = document.createElement('a');
                link.href = checkbox.value;
                link.download = checkbox.value;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            });
        }
    </script>
</head>
<body>
    <div class="download-buttons">
        <button onclick="downloadMarkedFiles()">Download Marked Files</button>
        <button onclick="downloadAllFiles()">Download All Files</button>
    </div>
    <div class="file-container">
EOF

        # Add file items to the HTML
        while read -r file; do
            # Extract the file name and trim spaces
            file=$(echo $file | awk -F": " '{print $2}')
            if [[ -f $file ]]; then
                file_icon=""
                case "${file##*.}" in
                    jpg|jpeg|png|gif)
                        file_icon="$file"
                        ;;
                    mp4|avi|mov)
                        file_icon="video-icon.png"  # Placeholder icon for video files
                        ;;
                    mp3|wav)
                        file_icon="audio-icon.png"  # Placeholder icon for audio files
                        ;;
                    txt)
                        file_icon="txt-icon.png"  # Placeholder icon for text files
                        ;;
                    pdf)
                        file_icon="pdf-icon.png"  # Placeholder icon for PDF files
                        ;;
                    doc|docx)
                        file_icon="doc-icon.png"  # Placeholder icon for document files
                        ;;
                    *)
                        file_icon="file-icon.png"  # Generic file icon
                        ;;
                esac

                # Copy the file to the current directory for preview and download purposes
                cp "$file" .

                # Generate HTML for each file
                cat <<EOF >> index.html
        <div class="file-item">
            <img src="$file_icon" alt="File">
            <input type="checkbox" name="fileCheckbox" value="$file">
            <div class="file-name">$file</div>
            <button onclick="window.location.href='$file'">Download</button>
        </div>
EOF
            fi
        done < filtered_files.txt

        # Complete HTML file
        cat <<EOF >> index.html
    </div>
</body>
</html>
EOF
    }

    # Main script
    echo "Choose an option to filter photos by date:"
    echo "1) Custom Date (YYYY/MM/DD)"
    echo "2) Yesterday"
    echo "3) Today"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter the date (YYYY/MM/DD): " custom_date
            exif_date=$(echo $custom_date | tr '/' ':')
            ;;
        2)
            exif_date=$(date -d "yesterday" "+%Y:%m:%d")
            ;;
        3)
            exif_date=$(date "+%Y:%m:%d")
            ;;
        *)
            echo "Invalid choice"
            exit 1
            ;;
    esac

    # Filter files based on the selected date and filter type
    if [[ $filter_type == "C" ]]; then
        exiftool -if '($CreateDate =~ /'"$exif_date"'/)' -FileName -q -r . > filtered_files.txt
    elif [[ $filter_type == "M" ]]; then
        exiftool -if '($FileModifyDate =~ /'"$exif_date"'/)' -FileName -q -r . > filtered_files.txt
    else
        exiftool -if '($FileModifyDate =~ /'"$exif_date"'/ || $CreateDate =~ /'"$exif_date"'/)' -FileName -q -r . > filtered_files.txt
    fi

    # Check if any files were found
    if [[ ! -s filtered_files.txt ]]; then
        echo "No images available for the date you provided."
        rm filtered_files.txt
        exit 1
    fi

    # Create the HTML file
    create_html_file

    # Ensure 'uploads' directory exists
    if [ ! -d "uploads" ]; then
        mkdir uploads
    fi

    # Function to clean up generated files
    cleanup() {
        echo "Cleaning up..."
        rm -f index.html filtered_files.txt
        echo "Server stopped and files cleaned up."
    }

    check_port() {
        local port=$1
        if lsof -i :$port &> /dev/null; then
            return 1 # Port is in use
        else
            return 0 # Port is available
        fi
    }

    find_available_port() {
        local port=80
        while ! check_port $port; do
            port=$((RANDOM % 65535 + 1024)) # Random port between 1024 and 65535
        done
        echo $port
    }

    generate_qr() {
        local interface_name=$1
        local ip_address=$2
        local port=$3
        if command -v qrcode-terminal &> /dev/null; then
            echo "Interface: $interface_name, IP: $ip_address, Port: $port"
            qrcode-terminal "http://${ip_address}:${port}"
        else
            echo "qrcode-terminal is not installed. Please install it using 'npm install -g qrcode-terminal'"
            exit 1
        fi
    }

    start_php_server() {
        local ip_address=$1
        local port=$2
        if command -v php &> /dev/null; then
            echo "Starting PHP server at http://${ip_address}:${port}"
            php -S "${ip_address}:${port}" &
            PHP_SERVER_PID=$!
            echo "PHP server is running with PID ${PHP_SERVER_PID}."
            echo "If you want to stop the server, press the enter button or any key."
        else
            echo "PHP is not installed. Please install PHP to run the server."
            exit 1
        fi
    }

    stop_php_server() {
        if [ -n "$PHP_SERVER_PID" ]; then
            kill $PHP_SERVER_PID
            echo "PHP server stopped."
        fi
    }

    # Check for IP addresses on all network interfaces and store interface names
    interface_info=$(ip -o -4 addr show | awk '$4 ~ /^10\.|^172\.16\.|^192\.168\./ {print $2, $4}' | cut -d/ -f1 | head -n 1)
    interface_name=$(echo $interface_info | awk '{print $1}')
    ip_address=$(echo $interface_info | awk '{print $2}')

    # Find an available port starting from 80
    port=$(find_available_port)

    if [ -n "$ip_address" ]; then
        generate_qr "$interface_name" "$ip_address" "$port"
        start_php_server "$ip_address" "$port"
    else
        echo "No IP address found for any interface. Generating QR code for localhost."
        generate_qr "localhost" "localhost" "$port"
        start_php_server "localhost" "$port"
    fi

    # Trap to handle termination, stop the PHP server, and clean up files
    trap "stop_php_server; cleanup" EXIT

    # Wait for user input to stop the server
    read -r -p "Press enter or any key to stop the server..."
    stop_php_server
}


# Main script logic
case $1 in
    -on)
        check_and_install_tools
        start_sharing
        ;;
    -on-en)
        check_and_install_tools
        share_with_encryption
        ;;
    -von)
        check_and_install_tools
        start_sharing_visual
        ;;
    -play-v)
        check_and_install_tools
        start_video_streaming
        ;;
        -u)
        start_upload
        ;;
        -p)
        check_and_install_tools
        share_photos
        ;;
    --help)
        show_help
        ;;
    *)
        echo "Invalid option. Use --help to see the available options."
        ;;
esac
