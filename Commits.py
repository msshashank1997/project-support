import requests
import datetime
from dotenv import load_dotenv
import os

# Replace these with your own values
GITHUB_REPO = "msshashank1997/Project"  # e.g., "octocat/Hello-World"
load_dotenv()  # Load environment variables from .env file
ACCESS_TOKEN = os.getenv("GITHUB_TOKEN")  # GitHub personal access token

def get_latest_commit_sha(repo, token):
    url = f"https://api.github.com/repos/{repo}/commits"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    commits = response.json()
    if commits:
        return commits[0]["sha"]
    return None

def check_for_new_commits(repo, token, last_known_sha):
    latest_commit_sha = get_latest_commit_sha(repo, token)
    if latest_commit_sha and latest_commit_sha != last_known_sha:
        print(f"New commit found: {latest_commit_sha}")
        return latest_commit_sha
    print("No new commits found.")
    return last_known_sha

def main():
    # Load the last known commit SHA from a file (or use a default value)
    try:
        with open("last_known_commit.txt", "r") as file:
            last_known_sha = file.read().strip()
    except FileNotFoundError:
        last_known_sha = None

    # Check for new commits
    last_known_sha = check_for_new_commits(GITHUB_REPO, ACCESS_TOKEN, last_known_sha)

    # Save the latest commit SHA to a file
    with open("last_known_commit.txt", "w") as file:
        file.write(last_known_sha)

if __name__ == "__main__":
    main()