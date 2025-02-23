# Flask Application with Nginx Load Balancer

This system runs multiple Flask instances with Nginx load balancing.

## Components

- `app.py` - Flask application
- `templates/` - HTML template files
- `nginx/default` - Nginx load balancer configuration

## Prerequisites

- Python 3.x
- Nginx
- Required Python packages:
  ```
  flask
  ```

## Flask Application Setup

1. Install Prerequisites:

   ```bash
   sudo apt update
   sudo apt install python3 python3-pip nginx
   pip3 install flask
   ```

2. Start Multiple Flask Instances:

   ```bash
   # Start first instance
   python app.py --port=5002
   
   # Start second instance (in new terminal)
   python app.py --port=5003
   
   # Start third instance (in new terminal)
   python app.py --port=5004
   ```
   or
   ```
   set FLASK_APP=app.py
   python -m flask run --port=5002
   python -m flask run --port=5003
   python -m flask run --port=5004
   ```

## Nginx Load Balancer Configuration

1. Edit the default site configuration:
   ```bash
   sudo nano /etc/nginx/sites-available/default
   ```

2. Add load balancer configuration:
   ```nginx
   upstream newapp {
       least_conn;  # Load balancing method
       server 127.0.0.1:5002;
       server 127.0.0.1:5003;
       server 127.0.0.1:5004;
   }

   server {
       listen 80;
       server_name _;

       location / {
           proxy_pass http://newapp;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

3. Test and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

## Load Balancing Strategies

The current configuration uses `least_conn` method for load balancing. Alternative options:
- `ip_hash` - Routes based on client IP (session persistence)
- `round_robin` - Default method, routes requests sequentially
- `least_conn` - Routes to server with fewest active connections

## Set up crontab

1. Make the update script executable:
   ```bash
   chmod +x /home/shashank/project-support/update_and_restart.sh
   ```

2. Open crontab editor:
   ```bash
   crontab -e
   ```

3. Add the following line to run the update script every hour:
   ```
   0 * * * * /home/shashank/project-support/update_and_restart.sh
   ```

4. Verify crontab setup:
   ```bash
   crontab -l
   ```

## Testing the Setup

1. Access the application:
   ```
   http://localhost
   ```

2. Monitor Nginx access logs:
   ```bash
   sudo tail -f /var/log/nginx/access.log
   ```

## Troubleshooting

1. Check Flask instances:
   ```bash
   ps aux | grep python
   ```

2. Verify Nginx status:
   ```bash
   sudo systemctl status nginx
   ```

3. Check Nginx error logs:
   ```bash
   sudo tail -f /var/log/nginx/error.log
   ```

4. Common issues:
   - Port conflicts
   - Permission issues

5. Nginx Permission denied 

   To resolve these issues, you can try the following steps:

   1. Run NGINX with super-user privileges: Ensure that you are running NGINX with super-user privileges. You can do this by using `sudo`:

      ```
      sudo nginx -t
      ```

   2. **Fix the permissions for the** /run/nginx.pid file: Ensure that the NGINX process has the necessary permissions to write to the `/run/nginx.pid` **file**. You can change the ownership and permissions of the directory and file:

      ```bash
      sudo chown -R nginx:nginx /run
      sudo chmod -R 755 /run
      ```

   3. After making these changes, test the NGINX configuration again:

      ```bash
      sudo nginx -t
      ```

   4. If the configuration test passes, you can restart NGINX:

      ```bash
      sudo systemctl restart nginx
      ```

