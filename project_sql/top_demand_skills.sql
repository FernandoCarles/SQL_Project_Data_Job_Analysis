
--What are the most in-demand skills for data scientist?

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
