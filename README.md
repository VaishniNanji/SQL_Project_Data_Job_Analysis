# Introduction
Explore the data job market 📊 with a focus on Data Analyst roles. This project highlights the highest-paying positions 💰, in-demand skills 🧠, and where high demand meets high salary in data analytics 🎯.

🔍 Check out the SQL queries here: [sql_project folder](/sql_project/)

# Background
During my search for a Data Analytics role, I decided to undertake this project as a way to strengthen my SQL skills and gain clear insights into the data analyst job market in 2023. By analysing real job postings, salary trends, and in-demand skills, I aimed not only to improve my technical abilities but also to better understand what employers are looking for. This project served as both a learning experience and a strategic tool to guide my job search, helping me identify the most valuable skills to focus on and the roles that aligned best with my career goals.

The data comes from this [SQL Course](https://lukebarousse.com/sql).

### The questions I wanted to answer through my SQL queries were:

1. Which companies in London or offering remote roles provide the highest-paying Data Analyst jobs?
2. What skills are required for these highest-paying Data Analyst jobs in London or remote?
3. What are the most in-demand skills for Data Analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn (skills high in-demand and high-paying) for a Data Analyst?

# Tools I Used

To explore the 2023 Data Analyst job market, I leveraged a set of essential tools to gather, manage, and analyse the data effectively:
- **SQL** - The core of my analysis, enabling me to query the dataset and uncover meaningful insights.
- **PostgreSQL** - My database management system of choice, perfectly suited for handling job posting data efficiently.
- **Visual Studio Code** - Served as my primary environment for writing and executing SQL queries, keeping my workflow smooth and organised.
- **Git & GitHub** - Essential for version control, sharing my SQL scripts and analysis, and tracking the evolution of my project.

# The Analysis
Every query in this project targeted a different angle of the data analyst job market. Below is an overview of how I tackled each question:

### 1. Top Paying Data Analysts Jobs
To identity the highest-paying roles, I filtered data analyst positions by average yearly salary and location, with a particular focus on remote opportunities. This query highlights the highest-paying roles in the field.

```sql
SELECT
    job_id,
    job_title,
    name AS company,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::DATE
FROM
    job_postings_fact
LEFT JOIN 
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
   (job_location = 'Anywhere' OR 
    job_location = 'London, UK') AND
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here is a breakdown of the top Data Analyst jobs in 2023:
- **Wide Salary Range**: The top 10 highest-paying Data Analyst roles range from $184,000 to $650,000, highlighting the strong earning potential within the field.
- **Diverse Employers**: High-paying roles come from a mix of companies, including SmartAsset, Meta, and AT&T, showing that competitive salaries span tech, telecom, finanace, and more.
- **Vareity of Job Titles**: Roles range from Data Analysts to Director of Analytics, reflecting the variety of specialisations and career levels within data analytics.
- **Remote Dominance**: Although the analysis included both London-based and remote positions, all top 10 highest-paying roles were remote, suggesting that remote opportunities tend to offer the most competitive salaries.

### 2. Skills for Top Paying Data Analyst Jobs
To identify which skills are required for the top 10 highest-paying data analyst jobs, I placed the query from Question 1 into a common table expression (CTE). In the main query, I then joined the job postings data with the skills data to provide insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
  SELECT
      job_id,
      job_title,
      salary_year_avg,
      name AS company
  FROM
      job_postings_fact
  LEFT JOIN 
      company_dim ON job_postings_fact.company_id = company_dim.company_id
  WHERE
      (job_location = 'Anywhere' OR 
      job_location = 'London, UK') AND
      job_title_short = 'Data Analyst' AND
      salary_year_avg IS NOT NULL
  ORDER BY
      salary_year_avg DESC
  LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
Here is a breakdown of the most demanded skills for the top 10 highest paying Data Analyst jobs in 2023:
- **SQL** is leading with a count of 8.
- **Python** follows closely with a count of 7.
- **Tableau** is the third most in-demand skill with a count of 6.
- Other skills such as **R** (4 roles), **Snowflake** (3 roles), **pandas** (3 roles), and **Excel** (3 roles) show varying degrees of demand.
- **Data Platforms & Cloud**: At least 6 roles mention modern data platforms (such as AWS, Azure, Snowflake, Databricks, Oracle, Hadoop, SAP), indicating strong demand for platform knowledge alongside analytics.
- **BI & Reporting**: Around 6 roles require BI/reporting tools like Tableau, Power BI, Excel, PowerPoint, Crystal, or Flow, underlining the importance of dashboards and communication.

### 3. In-Demand Skills for Data Analysts
This analysis highlighted the skills most frequently requested in job postings, helping prioritise those with the highest demand.

```sql
SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location = 'Anywhere' OR
    job_location = 'London, UK')
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

Here is the breakdown of the most demanded skills for Data Analysts in 2023:
- SQL and Excel remain fundamental, showing the need for strong skills in data processing and spreadsheet manipulation.
- **Programming & Visualisation** - Python, Tableau, and Power BI are key technical tools, reflecting how important coding and visualisation are for data storytelling and supporting decisions.

| Skill    | Demand Count |
|----------|--------------|
| SQL      | 7473         |
| Excel    | 4709         |
| Python   | 4482         |
| Tableau  | 3817         |
| Power BI | 2676         |
*Table of the demand for the top 5 skills in Data Analyst job postings*

### 4. Skills Based on Salary
Analysing the average salaries linked to different skills highlighted which ones are associated with the highest pay.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg is NOT NULL AND
    (job_location = 'Anywhere' OR
    job_location = 'London, UK')
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

Here is a breakdown of the results for top paying skills for Data Analysts in 2023:
- **Big data skills are most highly rewarded**: Tools like PySpark and Databricks are strongly associated with the highest-paying Data Analyst roles.
- **Machine Learning (MI) & Artificial Intelligence (AI) frameworks stand out**: Skills in TensorFlow, PyTorch, Watson, and DataRobot are common among the top-paying positions, showing a shift toward machine learning-heavy analytics.
- **Python data ecosystem is a strong signal of higher pay**: Experience with pandas, Jupyter, NumPy, and related tools is consistently linked to better-paying roles.
- **Engineering and DevOps skills boost earning potential**: Knowledge of tools like GitLab/Bitbucket, Linux, Kubernetes, Jenkins, and Atlassian platforms often appears in the highest-paid analyst jobs.
- **Modern data infrastructure skills add value**: Working with technologies such as Couchbase, Elasticsearch, PostgreSQL, and Airflow is also associated with higher salaries, indicating demand for analysts who understand production data systems and pipelines.

| Skill      | Average Salary (USD) |
|----------- |----------------------|
| pyspark    | 208172               |
| bitbucket  | 189155               |
| tensorflow | 177283               |
| pytorch    | 177283               |
| watson     | 160515               |
| couchbase  | 160515               |
| datarobot  | 155486               |
| gitlab     | 154500               |
| pandas     | 154368               |
| swift      | 153750               |
*Table of the average salary for the top 10 paying skills for Data Analysts*

### 5. Most Optimal Skills to Learn
This analysis combined demand and salary data to identify skills that are both widely sought after and highly paid, helping to prioritise the most strategic areas for skill development.

```sql
SELECT
    skills_job_dim.skill_id,
    skills,
    COUNT(skills_job_dim.skill_id) AS demand_count,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    (job_location = 'Anywhere' OR
    job_location = 'London, UK')
GROUP BY
    skills_job_dim.skill_id,
    skills
HAVING
    COUNT(skills_job_dim.skill_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
Here is a breakdown of the most optimal skills for Data Analysts in 2023:
- Skills that combine high demand and strong salaries in this data include: Python, R, Tableau, Looker, Snowflake, Azure, AWS, Oracle, SQL Server, SAS.
- **Cloud and data platforms** such as Snowflake, Azure, AWS, BigQuery, Redshift, Oracle, SQL Server, and NoSQL appear frequently among the better-paid roles.
- **Programming & big data tools** like Python, R, Go, Java, C++, and Hadoop are present in higher-paying roles, indicating strong value for more technical profiles.
- **BI & analytics tools** including Tableau, Looker, Qilk, SSRS, SAS, and DAX are both in demand and linked with good salaries, showing that dashboard and reporting skills remain important.
- **Enterprise & workflow tools** such as SSIS, Jira, Confluence occur in well-paid roles, reflecting their use in mature, enterprise data environments.

| Skill       | Demand Count | Average Salary (USD) |
|------------|--------------|----------------------|
| Confluence | 11           | 114210               |
| Hadoop     | 22           | 113193               |
| Snowflake  | 38           | 112103               |
| Go         | 31           | 111967               |
| Azure      | 37           | 110737               |
| AWS        | 32           | 108317               |
| BigQuery   | 14           | 107596               |
| Java       | 17           | 106906               |
| SSIS       | 12           | 106683               |
| NoSQL      | 14           | 105869               |
*Table of the most optimal skills for Data Analyst sorted by salary*

# What I Learned
Throughout this project, I strengthened a range of practical SQL skills:
- **Writing Advanced Queries**: Building more complex queries that join multiple tables and use WITH (CTEs) to break problems into clear, reusable steps.
- **Effective Data Aggregation**: Using GROUP BY, COUNT(), AVG(), and other aggregate functions to summarise large datasets and surface key trends.
- **Filtering & Structuring Results**: Applying WHERE, HAVING, and ORDER BY to refine query outputs and focus only on the most relevant records.
- **Analytical Problem-Solving**: Turning real-world business questions into precise SQL queries that produced clear, data-driven answers.
- **Reusable, Readable SQL**: Writing cleaner, well-structured queries that are easier to debug, explain, and build on in future analysis.

# Insights
1. **Top-Paying Roles**

    The highest-paying remote Data Analyst roles span a wide range, with salaries up to $650,000, showing very high earning potential for senior or specialised positions.

2. **Most In-Demand Skills**

    Across job postings, SQL is the most in-demand skill, followed by Excel, Python, Tableau, and Power BI, making them core requirements for many data analyst roles.

3. **Skills Linked to Higher Salaries**

    The highest average salaries are associated with more advanced and technical skills such as PySpark, TensorFlow, PyTorch, Databricks, GitLab/Bitbucket, Linux, Kubernetes, and modern data/ML tools like pandas, Jupyter, and NumPy.

4. **Best Balance of Demand and Pay**

    When combining demand and salary, skills like Python, R, Tableau, Looker, Snowflake, Azure, AWS, Oracle, SQL Server, and SAS stand out as offering both strong job opportunities and competitive pay.

# Conclusions
This project strenghtened my practical SQL skills and gave me a clearer picture of the 2023 Data Analyst job market. By working with real job posting data, I learned which skills are most in demand, which ones are linked to higher salaries, and where they overlap to offer the strongest value for skill development.

The results highlight a clear priority stack for aspiring Data Analysts: start with SQL as the core, build strong skills in Excel, Python, and BI tools like Tableau or Power BI, and then add high-value skills such as cloud data warehouses and big data/ML tools as a next step. Overall, this analysis reinforced the importance of continuous upskilling and staying aligned with current market trends to stay competitive in the field.