# FileShare
![File Share ](https://img.shields.io/badge/File%20Share%20-blue?style=flat) || ![Auto Compass](https://img.shields.io/badge/Auto%20Compass-purple?style=flat) || ![Direct Download](https://img.shields.io/badge/Direct%20Download-brightgreen?style=flat-square) || ![KALI NETHUNTER ](https://img.shields.io/badge/KALI%20NETHUNTER%20-blue?style=flat) || ![Share with QR](https://img.shields.io/badge/Share%20with%20QR-blueviolet?style=plastic) || ![Share with password](https://img.shields.io/badge/Share%20with%20password-orange?style=flat) || ![Made with](https://img.shields.io/badge/Made%20with-bash-%23ff0000?style=flat-square&logo=bash&logoColor=white&labelColor=%23000000)

## Description

`share.sh` is a versatile script designed to simplify file sharing directly from your terminal. It can be used on Kali Nethunter, Kali Linux, and Termux environments. The script provides options for sharing files, stopping the sharing process, and even sharing files with password encryption for added security.

## How To Use

### Options

- `share -on` 
  - Share all files in the current directory.
- `share -p` 
  - Through it you can share photos of specific dates.`.
- `share -von` 
  - All the files in the directory can be displayed on the website..
- `share -on-en` 
  - Share all files in the current directory with password encryption.
- `share --help` 
  - Display the help message.
- `share -play-v` 
  - You can play all the videos of the current director.
- `share -u` 
  - start PHP upload server.
  
### Commands

- To share files in the current directory:
  ```sh
  share -on
  ```


- To share files with password encryption:
  ```sh
  share -on-en
  ```

- To display the help message:
  ```sh
  share --help
  ```

## How To Install

1. **Download the Script:**

   Download the script from the GitHub repository:
   ```sh
   wget https://github.com/mashunterbd/FileShare/blob/main/share.sh -O share.sh
   ```

2. **Make the Script Executable:**

   Give execution permission to the script:
   ```sh
   chmod +x share.sh
   ```

3. **Move the Script to a System Directory (Optional):**

   If you want to make the script accessible from anywhere:
   ```sh
   sudo mv share.sh /usr/local/bin/share
   ```

4. **Run the Script:**

   Use the `share` command followed by any of the options mentioned above.

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
