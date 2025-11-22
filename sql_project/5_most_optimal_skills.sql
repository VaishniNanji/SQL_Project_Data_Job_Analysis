/* Question: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis */

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

/* Query using CTE */

WITH high_demand_skills AS (
    SELECT
        skills_job_dim.skill_id,
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
        job_location = 'London, UK') AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id,
        skills
),

high_paying_roles AS (
SELECT
    skills_job_dim.skill_id,
    AVG(salary_year_avg) AS avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg is NOT NULL AND
    (job_location = 'Anywhere' OR
    job_location = 'London, UK')
GROUP BY
    skills_job_dim.skill_id
)

SELECT
    high_demand_skills.skills,
    demand_count,
    ROUND(avg_salary, 0) AS avg_salary
FROM
    high_demand_skills
INNER JOIN 
    high_paying_roles ON high_demand_skills.skill_id = high_paying_roles.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

