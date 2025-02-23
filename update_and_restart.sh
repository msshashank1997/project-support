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
        cd /home/shashank/project-support
        sudo git pull origin main
        cd /home/shashank/project-support/flask-template
        docker build -t flask-multi-port:latest .
        
        # Stop and remove all existing containers
        docker stop flask-multi-port-1 flask-multi-port-2 flask-multi-port-3 || true
        docker rm flask-multi-port-1 flask-multi-port-2 flask-multi-port-3 || true
        
        # Run containers with specific names and ports
        docker run -d --name flask-multi-port-1 -p 5002:5002 flask-multi-port:latest
        docker run -d --name flask-multi-port-2 -p 5003:5003 flask-multi-port:latest
        docker run -d --name flask-multi-port-3 -p 5004:5004 flask-multi-port:latest
        sudo systemctl restart nginx
    fi
}

# Run the function
check_commits
