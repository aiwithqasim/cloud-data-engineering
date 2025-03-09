# CLOUD DATA ENGINEERING

![cloud-data-enginnering-logo](./img/cloud-data-engineering.png)

Welcome to the **Cloud Data Engineering** course! This comprehensive 6-8 month journey is designed to equip you with the necessary skills to become a proficient Data Engineer, focusing on cloud-based technologies, data acquisition, modeling, warehousing, and orchestration. Our curriculum is divided into **5 modules** that include hands-on projects, assignments, and real-world case studies to ensure a practical understanding of the technologies covered.

---

This repository include the Roadmap for Data Engineering. Since Data Engineering is a broad field we'll try to cover following tools.

**VERSION: 1.3.0**

---

## Table of Contents

1. [Course Overview](#course-overview)
2. [Understanding Data Engineering](#understanding-data-engineering)
3. [Module 1: Data Acquisition](#module-1-data-acquisition)
4. [Module 2: Data Modeling](#module-2-data-modeling)
5. [Module 3: Cloud Data Warehousing](#module-3-cloud-data-warehousing)
6. [Module 4: Data Orchestration & Streaming](#module-4-data-orchestration--streaming)
7. [Module 5: Architecting AWS Data Engineering Projects](#module-5-architecting-aws-data-engineering-projects)
8. [Why These Technologies?](#why-these-technologies)
9. [Final Notes](#final-notes)

---

## Course Overview

This course is meticulously crafted to cover all facets of Cloud Data Engineering. You'll learn everything from the basics of data acquisition and transformation to advanced cloud-based data warehousing, orchestration, and streaming techniques. The course is structured to build your skills progressively, ensuring you are ready to tackle complex data engineering challenges by the end.

---

## Understanding Data Engineering

Before starting the digging deep into the field of Data Engineering one should know what is Data Engineering, What is the Scope of Data ENgineering in 2024, what tools are required to have knowledge for data engineering.

- [Understanding Data Engineering](./docs/Understanding%20Data%20Engineering.pptx)

---

## Module 1: Data Acquisition

### Overview

The focus of this module is on acquiring, manipulating, and processing data from various sources. You'll set up your data engineering environment, explore Python for data manipulation, manage projects with version control, and gain hands-on experience with web scraping using BeautifulSoup and Selenium.

### Topics Covered

1. **Introduction to Data Engineering + Python Setup**

   - **Objective**: Understand the fundamentals of Data Engineering and Python setup.
   - **Outcome**: Be proficient in setting up Python and tools for data handling.

   ##### Learning Resources:

   - [Python - Zero to Hero](https://www.w3schools.com/python/)
   - [Python Programming by Qasim Hassan](https://github.com/aiwithqasim/Saylani_Python_911)

   It is recommended to watch the video at 1.5x or 2.0x speed. Some concepts are covered way to

   ##### Youtube Resource:

   - [Python - A Complete Guide (Youtube)](https://youtu.be/UrsmFxEIp5k?si=TeqtYzKYPO9VWvLH)

2. **Python for Data Engineering (Numpy + Pandas) + Case Study**

   - **Objective**: Data manipulation using Pandas.
   - **Case Study**: Clean and analyze real-world datasets using Pandas.

   ##### Learning Resources:

   - [EDA using Numpy Pandas & Matplotlib](https://github.com/aiwithqasim/Explorartory_Data_Analysis)
   - [Numpy and Pandas - Beginner to Advanced](https://github.com/MuhammadUzair1/Saylani-CDE-Batch1)

   ##### Practice:

   - [Numpy - Zero to Hero](https://github.com/MuhammadUzair1/Saylani-CDE-Batch1/tree/main/Numpy/Exercises)
   - [Pandas - Data Cleaning](https://github.com/MuhammadUzair1/Case-Study-Data-Cleaning)

   ##### Case Study:

   - [Analyzing Airbnb Market Trends](https://github.com/MuhammadUzair1/EDA-Project-Airbnb-Market-Trends)

   ##### Projects:

   - [Project-1 Investigating Netflix Movies and Guest Stars in The Office](https://github.com/aiwithqasim/datascience-projects/tree/main/Investigating%20Netflix%20Movies%20and%20Guest%20Stars%20in%20The%20Office)
   - [Project-2 The Android App Market on Google Play](https://github.com/aiwithqasim/datascience-projects/tree/main/The%20Android%20App%20Market%20on%20Google%20Play/The%20Android%20App%20Market%20on%20Google%20Play)
   - [Project-3 The GitHub History of the Scala Language](https://github.com/aiwithqasim/datascience-projects/tree/main/The%20GitHub%20History%20of%20the%20Scala%20Language)

3. **Version Control (Git + Python Project)**

   - **Objective**: Learn Git for version control and collaboration.
   - **Assignment**: Create a Python project and push it to GitHub.

   ##### Tutorial:

   [Git and Github Tutorial](https://github.com/MuhammadUzair1/Git-and-Github-Tutorial)

4. **Bash/Shell Scripting**

   Bash/Shell scripting and Linux commands are vital in a Cloud Data Engineering roadmap due to their automation capabilities, essential for tasks like data processing and infrastructure management. Proficiency ensures flexibility, troubleshooting skills, and compatibility with cloud platforms. Cost optimization through efficient resource usage and the ability to streamline version control and deployment processes further emphasizes their importance.

   - **Objective**: Automate repetitive tasks using Shell scripts.
   - **Assignment**: Automate a data acquisition task using Bash.

   ##### Learning Resources:

   - [Introduction to Shell](https://www.datacamp.com/courses/introduction-to-shell)
   - [Introduction Bash Scripting](https://www.datacamp.com/courses/introduction-to-bash-scripting)
   - [Data processing in Shell](https://www.datacamp.com/courses/data-processing-in-shell)

   ##### Project: Security Log Analysis

   You're responsible for the security of a server, which involves monitoring a log file named security.log. This file records security-related events, including successful and failed login attempts, file access violations, and network intrusion attempts. Your goal is to analyze this log file to extract crucial security insights.

   Create a sample log file named `security.log` with the following format:

   ```
   2024-03-29 08:12:34 SUCCESS: User admin login
   2024-03-29 08:15:21 FAILED: User guest login attempt
   2024-03-29 08:18:45 ALERT: Unauthorized file access detected
   2024-03-29 08:21:12 SUCCESS: User admin changed password
   2024-03-29 08:24:56 FAILED: User root login attempt
   2024-03-29 08:27:34 ALERT: Possible network intrusion detected.
   ```

5. **Docker w.r.t Data Engineering**

   Docker is integral to a Cloud Data Engineering roadmap for its ability to encapsulate data engineering environments into portable containers. This ensures consistency across development, testing, and production stages, facilitating seamless deployment and scaling of data pipelines. Docker's lightweight nature optimizes resource utilization, enabling efficient utilization of cloud infrastructure. Moreover, it promotes collaboration by simplifying the sharing of reproducible environments among team members, enhancing productivity and reproducibility in data engineering workflows.

   ##### Learning Resources:

   - [Intro to Docker & using Docker in Cloud Data Engineering](https://www.youtube.com/watch?v=98dp_4m2nO8)
   - [45-Minute Guide to Basic Data Engineering with Docker, PostgreSQL, and Python](https://www.youtube.com/watch?v=pqL24EHPwqw)

6. **Web Scraping with BeautifulSoup**

   - **Objective**: Extract data from static websites.
   - **Assignment**: Scrape data from a webpage and save it in CSV/JSON format.

7. **Web Scraping with Selenium**

   - **Objective**: Scrape data from dynamic websites.
   - **Assignment**: Create a Selenium script to scrape data from an e-commerce site.

## Module 2: Data Modeling

### Overview

Dive into database design, emphasizing efficient data storage, retrieval, and optimization. Learn SQL for data manipulation and advanced querying techniques.

### SQL Server Installation Guide & Setup

In this tutorial, you will learn to install SQL Server 2022 Developer Edition and SQL Server Management Studio (SSMS).

[SQL Server & SSMS Installation](https://www.sqlservertutorial.net/getting-started/install-sql-server/)

### Topics Covered

1. **SQL Fundamentals with SQL Server**

   - Basic operations: `SELECT`, `WHERE`, `ORDER BY`
   - Data integrity using constraints

2. **Data Definition and Manipulation**

   - Create and alter database structures using DDL
   - Modify data within tables using DML

3. **Advanced Querying Techniques**

   - Aggregations, `GROUP BY`, and set operations like `UNION`, `INTERSECT`, `EXCEPT`
   - Use `CUBE` and `ROLLUP` for multidimensional analysis

4. **Joining Data**

   - Mastering `INNER`, `LEFT`, `RIGHT`, and `FULL OUTER` joins

5. **Performance and Structure**

   - Query optimization with indexes
   - Utilizing `VIEWS` and `SUBQUERIES`

6. **Advanced SQL Concepts**

   - Use Common Table Expressions (CTEs) and Window Functions

7. **Encapsulating Logic**
   - Writing `STORED PROCEDURES` and using `TRIGGERS`

### SQL Tutorials

- [SQL Server Tutorial](https://www.sqlservertutorial.net/)
- [connecting to SQL Server using Python](https://pieriantraining.com/python-tutorial-how-to-connect-to-sql-server-in-python/)

### Project

- [Project-1 Getting started with ETL using Python + Pandas + SQL](https://www.youtube.com/watch?v=uL0-6kfiH3g&list=PLBTZqjSKn0Ie0FvR3_ass_iTIqYV_CAth&index=2)

## Module 3: Cloud Data Warehousing

### Overview

Master cloud-based data warehousing with Snowflake, focusing on scalability and handling large datasets. Gain hands-on experience through badge assignments and projects.

### Topics Covered

1. **Snowflake Overview**

   - Setting up your Snowflake environment

2. **Badges Assignment**

- [Badge 1: Data Warehousing Workshop](http://learn.snowflake.com/en/courses/uni-essdww101/)
- [Badge 2: Collaboration, Marketplace & Cost Estimation Workshop](http://learn.snowflake.com/en/courses/uni-ess-cmcw/)
- [Badge 3: Data Application Builders Workshop](http://learn.snowflake.com/en/courses/uni-ess-dabw/)
- [Badge 4: Data Lake Workshop](http://learn.snowflake.com/en/courses/uni-ess-dlkw/)
- [Badge 5: Data Engineering Workshop](http://learn.snowflake.com/en/courses/uni-ess-dngw/)

3. **Snowflake Masterclass (Udemy)**

   - Working through 5 sections of the course to solidify understanding [Snowflake – The Complete Masterclass](https://www.udemy.com/course/snowflake-masterclass/)

### Projects:

- [Project -3 Snowflake real time Data Warehouse for beginners](https://www.projectpro.io/project-use-case/snowflake-real-time-data-warehouse-project-for-beginners)
- [Project -4 Change Data Captue Pipeline with Snowflake & AWS ](https://www.projectpro.io/project-use-case/how-to-implement-slowly-changing-dimensions-in-snowflake)

---

## Module 4: Data Orchestration & Streaming

### Overview

Explore data pipeline management with Apache Airflow and real-time data streaming with Apache Kafka.

### Airflow

When we have a Data Pipeline & we want to trigger it on daily basis so we need some kind of automation or orchestration tool that can automate our orchestration part. for that purposes Airflow is the quite adopted choice to learn that why we have airflow in our roadmap.

##### Learning Resource:

- [The Complete Hands-On Introduction to Apache Airflow](https://awscloudclubs.udemy.com/course/the-complete-hands-on-course-to-master-apache-airflow/)

##### Projects:

- [Project -4 Twitter Data Pipeline using Airflow](https://www.youtube.com/watch?v=q8q3OFFfY6c&t=1665s)
- [Project -5 Automate a python ETL pipeline with airflow on AWS EC2](https://www.youtube.com/watch?v=uhQ54Dgp6To)
- [Project -6 Deploying Airflow with Docker](https://www.youtube.com/watch?v=COMEVcZtx1s)

### Kafka

When data is coming in the real-time fashion & suppose we don't have end destination ready to consume that data or let say any diaster happen. In this case we'll lose our data. This itroduce the need of de-coupling tool that can seperate both produce ends of the data & consumer end of the & act as mediator.

##### Learning Resource:

- [Apache Kafka Series - Learn Apache Kafka for Beginners](https://awscloudclubs.udemy.com/course/apache-kafka/)

##### Project:

- [Project -7 Stock Market Real-Time Data Analysis Using Kafka](https://www.youtube.com/watch?v=KerNf0NANMo&t=318s)

---

## Module 5: Architecting AWS Data Engineering Projects

### AWS

Dive deep into architecting data engineering solutions using AWS services. This module covers a wide range of tools from data storage, ETL, real-time data processing, to serverless computing.

### Why AWS?

AWS is crucial in a Cloud Data Engineering roadmap due to its comprehensive suite of services tailored for data processing, storage, and analytics. Leveraging AWS allows data engineers to build scalable and cost-effective data pipelines using services like S3, Glue, and EMR. Integration with other AWS services enables advanced analytics, machine learning, and real-time processing capabilities, empowering data engineers to derive valuable insights from data. Furthermore, AWS certifications validate expertise in cloud data engineering, enhancing career prospects and credibility in the industry.

### Topics Covered

1. **AWS Redshift**
   - Build and manage cloud-based data warehouses
2. **AWS S3**
   - Store and manage data efficiently
3. **AWS Glue & Athena**
   - Master ETL processes and querying
4. **AWS Lambda**
   - Automate workflows with serverless functions
5. **AWS EC2**
   - Manage compute resources for data processing
6. **AWS RDS**
   - Relational database management
7. **AWS Kinesis**
   - Real-time data streaming solutions

##### Learning Resource:

- [Data Engineering with AWS Services](https://www.udemy.com/course/data-engineering-using-aws-analytics-services/)

##### Projects:

- [Project -8 Batch Data Pipeline Using S3, lambda & Cloud Watch](https://www.youtube.com/watch?v=FF6SQEHBW0k)
- [Project -9 ETL pipeline using Glue, Athena & S3](https://www.youtube.com/watch?v=yIc5a7C8aHs)
- [Project -10 Super Store Data Analysis Using Glue & Quick Sight](https://www.youtube.com/watch?v=52CWagk3-jw)
- [Project -11 Extract and Transform Redfin data with AWS EMR ](https://www.youtube.com/watch?v=PeaLln90YXg&list=PLACD_PaYcVF0wXU-UIuC6mhvJZ0uu0TlP&index=1)
- [Project -12 End-To-End Data Engineering Project ](https://www.youtube.com/watch?v=efeP4IaOC8I)

---

## Why These Technologies?

The technologies selected in this course are widely used in the data engineering industry. Python, SQL, Snowflake, Apache Airflow, and AWS are among the most in-demand skills, ensuring that you are job-ready by the end of this course. Each module builds upon the previous one, enabling you to apply theoretical knowledge to real-world projects.

---

## Final Notes

Throughout the course, you will engage in hands-on projects and assignments that simulate real-world data engineering tasks. This practical experience is crucial for mastering the skills required to excel in the field of Cloud Data Engineering.

Get ready to embark on this exciting journey of becoming a proficient Cloud Data Engineer! 🚀

---
