-- **Question: What are the most in-demand skills for data analysts?**

-- - Identify the top 5 in-demand skills for a data analyst.
-- - Focus on all job postings.
-- - Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers.


select

skills_dim.skills, count(job_postings_fact.job_id) as job_count
from job_postings_fact
left join skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
left join skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
where job_postings_fact.job_title_short = 'Data Analyst' 
-- and job_postings_fact.job_work_from_home = True 
group by skills_dim.skills
order by job_count desc
limit 5;
