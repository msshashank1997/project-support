# Automated GitHub Repository Update System

This system automatically monitors a GitHub repository for new commits and updates a local deployment when changes are detected. It supports both Windows and Linux environments.

## Components

- `Commits.py` - Python script to check for new GitHub commits
- `update_and_restart.sh` - Linux shell script for continuous monitoring and updates
- `update_and_reset.ps1` - Windows PowerShell script for continuous monitoring and updates
- `latest_commit.json` - Stores the latest commit SHA

## Prerequisites

- Python 3.x
- Git installed and configured
- GitHub Personal Access Token
- Required Python packages:
  ```
  requests
  python-dotenv
  ```

## Setup Instructions

### Windows Setup

1. Install Prerequisites:
   - Install Python 3.x from python.org
   - Install Git from git-scm.com
   - Install Nginx for Windows

2. Directory Setup:
   
   ```
   D:\New folder\              # Main script directory
   C:\nginx\nginx-1.27.4\      # Nginx installation
   C:\nginx\nginx-1.27.4\html\ # Web root directory
   ```

3. Create Required Files:
   
   ```powershell
   # Create script directory if it doesn't exist
   New-Item -ItemType Directory -Force -Path "D:\New folder"
   ```
   
4. Start Monitoring:
   
   ```powershell
   # Run as Administrator
   cd "D:\New folder"
   .\update_and_reset.ps1
   ```

### Linux/Ubuntu Setup

1. Install Prerequisites:
   
   ```bash
   sudo apt update
   sudo apt install python3 python3-pip git nginx
   pip3 install requests python-dotenv
   ```

2. Directory Setup:
   
   ```bash
   /home/user/runscript/     # Script directory
   /var/www/html/           # Web root directory
   ```

3. Create Required Files:
   
   ```bash
   # Create script directory
   mkdir -p ~/runscript
   cd ~/runscript
   ```
   
4. Configure Scripts:
   
   ```bash
   # Set up script directory
   mkdir ~/runscript
   cp * ~/runscript/
   cd ~/runscript
   
   # Create .env file
   echo "GITHUB_TOKEN=your_token_here" > .env
   
   # Set permissions
   chmod +x update_and_restart.sh
   ```

5. Start Monitoring:
   
   ```bash
   # Run in background
   nohup ./update_and_restart.sh &
   ```

## Nginx Configuration

### Linux Configuration
Edit the default site configuration:

```bash
sudo nano /etc/nginx/sites-available/default
```

Update the root directory:
```nginx
server {
    root /home/user/runscript/html;
    index index.html index.htm;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
```

### Windows Configuration
Edit the Nginx configuration file:

```powershell
notepad C:\nginx\nginx-1.27.4\conf\nginx.conf
```

Update the server block:
```nginx
http {
    server {
        root   D:/New folder/html;
        index  index.html index.htm;
        
        location / {
            try_files $uri $uri/ =404;
        }
    }
}
```

After making changes:
- Linux: `sudo nginx -t` to test and `sudo systemctl reload nginx` to apply
- Windows: `nginx -t` to test and `nginx -s reload` to apply

## How It Works

1. The system checks for new commits every 10 minutes
2. When a new commit is detected:
   - The local repository is updated via `git pull`
   - The web server is restarted/reloaded
   - Windows: Nginx is reloaded
   - Linux: Nginx service is restarted

## Configuration

- Update the `GITHUB_REPO` variable in `Commits.py` to your repository
- Adjust the paths in the scripts to match your system configuration
- Modify the sleep duration if needed (currently set to 600 seconds/10 minutes)

## Security Note

Ensure your GitHub token has appropriate permissions and is kept secure. Never commit the `.env` file to version control.

## Troubleshooting

### Windows Issues
- Ensure PowerShell is running as Administrator
- Check if Nginx paths are correct in update_and_reset.ps1
- Verify Git is in system PATH

### Linux Issues
- Check file permissions (especially for /var/www/html)
- Ensure nginx service is running: `sudo systemctl status nginx`
- Verify Python dependencies are installed globally or in a virtual environment

## Additional Notes

- Windows users: The PowerShell script uses a 10-minute interval
- Linux users: The bash script runs continuously in the background
- Both systems create a log file of commit checks
