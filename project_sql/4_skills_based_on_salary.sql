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
and job_postings_fact.job_work_from_home = True --only done for remote jobs, not in this question
group by skill_name
order by avg_salary desc
limit 10;

/*
[
  {
    "skill_name": "pyspark",
    "avg_salary": "208172"
  },
  {
    "skill_name": "bitbucket",
    "avg_salary": "189155"
  },
  {
    "skill_name": "watson",
    "avg_salary": "160515"
  },
  {
    "skill_name": "couchbase",
    "avg_salary": "160515"
  },
  {
    "skill_name": "datarobot",
    "avg_salary": "155486"
  },
  {
    "skill_name": "gitlab",
    "avg_salary": "154500"
  },
  {
    "skill_name": "swift",
    "avg_salary": "153750"
  },
  {
    "skill_name": "jupyter",
    "avg_salary": "152777"
  },
  {
    "skill_name": "pandas",
    "avg_salary": "151821"
  },
  {
    "skill_name": "elasticsearch",
    "avg_salary": "145000"
  }
]
*/