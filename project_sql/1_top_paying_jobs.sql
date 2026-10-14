-- **Question: What are the top-paying data analyst jobs?**

-- - Identify the top 10 highest-paying Data Analyst roles that are available remotely.
-- - Focuses on job postings with specified salaries.

select
job_postings_fact.job_id,
job_postings_fact.job_title,
company_dim.name as company_name,
job_postings_fact.job_location,
job_postings_fact.job_schedule_type,
job_postings_fact.salary_year_avg,
job_postings_fact.job_posted_date
from job_postings_fact
left join company_dim 
on job_postings_fact.company_id = company_dim.company_id
where job_title_short='Data Analyst' and job_work_from_home=True
and salary_year_avg is not null
order by salary_year_avg desc
limit 10;