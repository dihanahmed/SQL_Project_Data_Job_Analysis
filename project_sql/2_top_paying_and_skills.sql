-- **Question: What are the top-paying data analyst jobs, and what skills are required?** 

-- - Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
-- - Filters for roles with specified salaries that are remote
-- - Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries

with top_paying_jobs as(
select
job_postings_fact.job_id as job_id,
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
limit 10
)

select top_paying_jobs. *, skills_dim.skills
from top_paying_jobs
left join skills_job_dim ON
top_paying_jobs.job_id = skills_job_dim.job_id
left join skills_dim ON
skills_job_dim.skill_id = skills_dim.skill_id
where skills_dim.skills is not null
order by top_paying_jobs.salary_year_avg desc;