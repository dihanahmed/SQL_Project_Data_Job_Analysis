-- **Answer: What are the top skills based on salary?** 

-- - Look at the average salary associated with each skill for Data Analyst positions.
-- - Focuses on roles with specified salaries, regardless of location.
-- - Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve.

select

skills_dim.skills as skill_name, 
round(avg(job_postings_fact.salary_year_avg), 0) as avg_salary -- for discarding decimal values
from job_postings_fact
left join skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
left join skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
where job_postings_fact.job_title_short = 'Data Analyst'
and job_postings_fact.salary_year_avg is not null and skills_dim.skills is not null
group by skill_name
order by avg_salary desc
limit 10;