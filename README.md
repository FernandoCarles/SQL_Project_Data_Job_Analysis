## -introduction
welcome to my SQL portafolio project, here i make an analysis into the data job market with a focus of Dana Scientist role, this is a exploration into identifying the top-paying roles and in-demand skills.

check out my SQL queries here: [project_sql folder](/project_sql/)
## -Background
I make thjis porject for my desire to understand data scientist job market better, I aimed to discover which skills are paid the most and in demand, making my job search more targeted and effective.

The data for this analysis is from Luke Barousse’s SQL Course [SQL course](https://www.lukebarousse.com/sql). This data includes details on job titles, salaries, locations, and required skills. 

The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data scientist jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data scientist?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data scientist looking to maximize job market value?

## Tools I used
- **SQL**: Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.

## Analysis
### 1. Top Paying Data Scientist Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field

```sql
SELECT
    job_id,
    job_title,
    job_location,
    salary_year_avg,
    job_posted_date,
    company_dim.name
FROM
    job_postings_fact
LEFT JOIN
    company_dim on job_postings_fact.company_id = company_dim.company_id
where
    job_title_short = 'Data Scientist'
    --and job_location = 'Anywhere' -- filter for remote jobs
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT
    10;
```
### 2. Skills for Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs as(
    SELECT
        job_id,
        job_title,
        job_location,
        salary_year_avg,
        job_posted_date,
        company_dim.name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim on job_postings_fact.company_id = company_dim.company_id
    where
        job_title_short = 'Data Scientist'
        and job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT
        10
)
-- Skills required for data scientist jobs
SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

### 3. In-Demand Skills for Data Scientist

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    skills,
    count(skills_job_dim.job_id) as demand_count
FROM
    job_postings_fact as jobs
INNER JOIN 
    skills_job_dim on jobs.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    --filter jobs for only data scientist role
    job_title_short = 'Data Scientist'
    --AND job_work_from_home = True -- optional to filter for remote jobs
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT
    10;
```
### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT
    skills,
    ROUND(avg(salary_year_avg), 2) as avg_salary --ROUND to 2 decimals 
FROM
    job_postings_fact as jobs
INNER JOIN 
    skills_job_dim on jobs.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    --filter jobs for only data scientist role
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT
    30;
```
### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
		skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
	INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	INNER JOIN
	    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Scientist'
		AND job_postings_fact.salary_year_avg IS NOT NULL
        --AND job_postings_fact.job_work_from_home = True
    GROUP BY
        skills_dim.skill_id
),
-- Skills with high average salaries for Data scientist roles
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        AVG(job_postings_fact.salary_year_avg) AS avg_salary
    FROM
        job_postings_fact
	INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_postings_fact.job_title_short = 'Data Scientist'
		AND job_postings_fact.salary_year_avg IS NOT NULL
        --AND job_postings_fact.job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id
)
-- Return high demand and high salaries for 10 skills 
SELECT
    skills_demand.skills,
    skills_demand.demand_count,
    ROUND(average_salary.avg_salary, 2) AS avg_salary --ROUND to 2 decimals 
FROM
    skills_demand
INNER JOIN
	average_salary ON skills_demand.skill_id = average_salary.skill_id
-- WHERE demand_count > 10
ORDER BY
    demand_count DESC, 
	avg_salary DESC
LIMIT 25; 
```

## **What I Learned**

Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.

## **Insights**

From the analysis, several general insights emerged:

1. **Top-Paying Data scientist Jobs**: The highest-paying jobs for data scientist that allow remote work offer a wide range of salaries, the highest at $960,000!
2. **Skills for Top-Paying Jobs**: High-paying data scientist jobs require advanced proficiency in python, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: Python is also the most demanded skill in the data scientist job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as asana and airtable, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: Python leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data scientist to learn to maximize their market value.

### **Conclusion**

This project enhanced my SQL skills and provided valuable insights into the data Scientist job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data Scientist can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data science.