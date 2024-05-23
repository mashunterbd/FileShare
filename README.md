# FileShare Script

## Description

`share.sh` is a versatile script designed to simplify file sharing directly from your terminal. It can be used on Kali Nethunter, Kali Linux, and Termux environments. The script provides options for sharing files, stopping the sharing process, and even sharing files with password encryption for added security.

## How To Use

### Options

- `share -on` 
  - Share all files in the current directory.
- `share -off` 
  - Stop sharing and delete `index.html` and `test.zip`.
- `share -off -r` 
  - Stop sharing and delete all files in the current directory.
- `share -on-en` 
  - Share all files in the current directory with password encryption.
- `share --help` 
  - Display the help message.

### Commands

- To share files in the current directory:
  ```sh
  share -on
  ```

- To stop sharing and delete `index.html` and `test.zip`:
  ```sh
  share -off
  ```

- To stop sharing and delete all files in the current directory:
  ```sh
  share -off -r
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
