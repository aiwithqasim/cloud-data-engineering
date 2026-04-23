Step 1:  Pull latest develop
         git checkout develop
         git pull origin develop

Step 2:  Create feature branch
         git checkout -b feature/my-airflow-dag

Step 3:  Build your feature, commit regularly
         git add .
         git commit -m "feat: add initial DAG structure"
         git commit -m "feat: add S3 sensor task"
         git commit -m "test: verify DAG parses correctly"

Step 4:  Push to GitHub
         git push -u origin feature/my-airflow-dag

Step 5:  Open Pull Request (PR) on GitHub
         - Title, description, screenshots if UI
         - Link to Jira/ticket
         - Assign reviewers

Step 6:  Code Review
         - Team reviews your code in PR comments
         - You make fixes, push more commits
         - Reviewer approves 

Step 7:  Merge PR → develop
         (GitHub merges it for you via the UI)

Step 8:  CI/CD runs automatically
         - Tests run
         - Code deploys to staging
         - If tests pass → merges to main → deploys to prod