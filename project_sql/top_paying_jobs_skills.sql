---- Gets the top 10 paying Data scientist jobs with their skills 

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