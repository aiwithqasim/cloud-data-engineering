4.1 — Setup (Run Once)

# Tell git who you are
git config --global user.name "Ayan Hussain"
git config --global user.email "ayan@gmai.com"

# Set default branch name to 'main'
git config --global init.defaultBranch main

# Verify your config
git config --list


4.2 — Creating a Repo from Scratch

# Create project folder & initialize git
mkdir my-de-project
cd my-de-project
git init

# Output:
# Initialized empty Git repository in /my-de-project/.git/

# Check status (always your first move)
git status

4.3 — Connecting to GitHub (Remote)

# Add GitHub repo as remote origin
git remote add origin https://github.com/ayanhussain81/my-de-project.git

# Verify remote was added
git remote -v

# Push for the first time (-u sets upstream tracking)
git push -u origin main

4.4 — The Core Daily Loop

# 1. Check what changed
git status

# 2. See exact line-by-line changes
git diff

# 3. Stage specific file
git add dag_etl.py

# 4. Or stage EVERYTHING
git add .

# 5. Commit with a message
git commit -m "feat: add retry logic to sales ETL pipeline"

# 6. Push to GitHub
git push origin main

4.5 — Cloning & Pulling

# Download a repo from GitHub
git clone https://github.com/ayanhussain81/cloud-data-engineering.git

# Get latest changes from team (do this every morning!)
git pull origin main