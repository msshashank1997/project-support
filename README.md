# Automated GitHub Repository Update System

This system automatically monitors a GitHub repository for new commits and updates a local deployment when changes are detected.

## Components

- `Commits.py` - Python script to check for new GitHub commits
- `update_and_restart.sh` - Shell script for continuous monitoring and updates
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

## Ubuntu Setup

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

## Nginx Configuration

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

After making changes:
```bash
sudo nginx -t          # Test configuration
sudo systemctl reload nginx  # Apply changes
```

## How It Works

1. The system checks for new commits every 10 minutes
2. When a new commit is detected:
   - The local repository is updated via `git pull`
   - The web server is restarted/reloaded
   - Nginx service is restarted

## Configuration

- Update the `GITHUB_REPO` variable in `Commits.py` to your repository
- Adjust the paths in the scripts to match your system configuration
- Modify the sleep duration if needed (currently set to 600 seconds/10 minutes)

## Security Note

Ensure your GitHub token has appropriate permissions and is kept secure. Never commit the `.env` file to version control.

## Troubleshooting

- Check file permissions (especially for /var/www/html)
- Ensure nginx service is running: `sudo systemctl status nginx`
- Verify Python dependencies are installed globally or in a virtual environment

## Crontab Configuration

### Setting Up Cron Jobs

You can automate the monitoring process using crontab instead of running the script manually.

1. Open crontab configuration:
   ```bash
   crontab -e
   ```

2. Add the following line to run the update check every hour:
   ```bash
   # Run update check at minute 1 of every hour
   1 * * * * /home/user/runscript/update_and_restart.sh >> /home/user/runscript/cron.log 2>&1
   ```

   Or for more frequent checks (every 10 minutes):
   ```bash
   # Run update check every 10 minutes
   */10 * * * * /home/user/runscript/update_and_restart.sh >> /home/user/runscript/cron.log 2>&1
   ```

### Managing Cron Jobs

- List current cron jobs:
  ```bash
  crontab -l
  ```

- Remove all cron jobs:
  ```bash
  crontab -r
  ```

- Check cron service status:
  ```bash
  sudo systemctl status cron
  ```

### Cron Log Monitoring

Monitor the cron job output:
```bash
tail -f /home/user/runscript/cron.log
```

Note: Ensure your script has proper logging mechanisms when run through cron, as it runs in a limited environment.
