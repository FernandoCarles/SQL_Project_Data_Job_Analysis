--Top 10 highest paying data scientist roles that are either remote or local

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