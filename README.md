# FileShare
This tool can help you to share your current directory files fast

# Information 
It is a customization tool. You can use it on your linux base system I made it for Kali NetHunter. It is the current of our own system that we can share the files of any director with another device very quickly and without using any third party sharing sources application. 

# Pre Requirements 
<b>npm </b> </br> 
<b>python3 </b> </br> 
<b>qrcode-terminal </b> </br> 
<b>server </b> </br> 
Note: server: This is another tool of mine that you must have installed on your system.If not installed you need to modify the script a bit.
# Install pre requirements packages if you don't have
```
sudo apt update
sudo apt install python3
pip install qrcode-terminal
```
# install server if not Installed 
```
wget https://raw.githubusercontent.com/mashunterbd/HTTP-Server/main/install.sh; chmod +x install.sh; ./install.sh
```
# Automatic install
```
wget https://raw.githubusercontent.com/mashunterbd/FileShare/main/share.sh; chmod +x share.sh; mv share.sh share; mv share /usr/local/bin/ && echo -e "install successful"
```
# Manually Install
```
git clone https://github.com/mashunterbd/FileShare.git 
cd FileShare 
mv share.sh share 
chmod +x share
mv share /usr/local/bin/ 
```
# How to use?

Bring the files you want to share to a specific directory and execute from that directory.
```
share
```
Then the tool will convert all the files in your current directory into a zip-file and generate a script to download this file for you and display the QR code in front of you terminal.
