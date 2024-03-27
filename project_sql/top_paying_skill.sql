-- Calculates the average salary for job postings by individual skill 

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