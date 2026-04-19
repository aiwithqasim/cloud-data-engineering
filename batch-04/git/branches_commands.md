# See all branches (* = current)
git branch

# See all branches including remote
git branch -a

# Create a new branch
git branch feature/airflow-dag

# Switch to it
git checkout feature/airflow-dag

# Create AND switch — the modern way (use this!)
git checkout -b feature/airflow-dag

# Push branch to GitHub
git push -u origin feature/airflow-dag

# Merge branch into main
git checkout main
git merge feature/airflow-dag

# Delete branch after merge (local)
git branch -d feature/airflow-dag

# Delete remote branch
git push origin --delete feature/airflow-dag