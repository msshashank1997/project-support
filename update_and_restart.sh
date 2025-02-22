
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
        cd /var/www/html/Project
        sudo git pull origin main
        sudo systemctl restart nginx
    fi
}

# Run the function
check_commits
