function check_commits {
    $output = python "D:\New folder\Commits.py"
    write-host $output

    if ($output -eq "No new commits found.") {
        write-host "No new commits found."
    }
    else {
        Set-Location C:\nginx\nginx-1.27.4\html\Project
        git pull https://github.com/msshashank1997/Project.git main
        Set-Location C:\nginx\nginx-1.27.4\
        & "C:\nginx\nginx-1.27.4\nginx.exe" -s reload
    }

    Start-Sleep -Seconds 600
}

while ($true) {
    check_commits
    sleep 36000
}