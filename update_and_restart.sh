check_commits() {
    # Run the commit.py file
    
    user=$(whoami)
    echo $user
    output=$(python3 /home/${user}/runscript/Commits.py)
    echo $output

    if [ "$output" = "No new commits found." ]; then
        echo "No new commits found."
    else
        echo "New commit found"
        cd /home/shashank/
        sudo git pull origin main
        cd /home/shashank/project-support/flask-template
        docker build -t flask-app:latest .
        
        # Stop and remove all existing containers
        docker stop flask-app-1 flask-app-2 flask-app-3 || true
        docker rm flask-app-1 flask-app-2 flask-app-3 || true
        
        # Run multiple containers with different ports
        docker run -d -p 5002:5002 --name flask-app-1 flask-app:latest
        docker run -d -p 5003:5002 --name flask-app-2 flask-app:latest
        docker run -d -p 5004:5002 --name flask-app-3 flask-app:latest
        
        sudo systemctl restart nginx
    fi
}

# Run the function
check_commits
