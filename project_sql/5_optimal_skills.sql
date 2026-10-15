-- **Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

-- - Identify skills in high demand and associated with high average salaries for Data Analyst roles
-- - Concentrates on remote positions with specified salaries
-- - Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis

with skill_demand as (
select
skills_dim.skills as skill_name, count(job_postings_fact.job_id) as job_count, skills_job_dim.skill_id as skill_id
from job_postings_fact
left join skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
left join skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
where job_postings_fact.job_title_short = 'Data Analyst' and skills_dim.skills is not null
and job_postings_fact.job_work_from_home = True
and job_postings_fact.salary_year_avg is not null
group by skills_dim.skills, skills_job_dim.skill_id
order by job_count desc
),

skill_based_on_salary as (
select
skills_dim.skills as skill_name, 
round(avg(job_postings_fact.salary_year_avg), 0) as avg_salary, -- for discarding decimal values
skills_job_dim.skill_id as skill_id
from job_postings_fact
left join skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
left join skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
where job_postings_fact.job_title_short = 'Data Analyst'
and job_postings_fact.salary_year_avg is not null and skills_dim.skills is not null
and job_postings_fact.job_work_from_home = True 
group by skill_name, skills_job_dim.skill_id
order by avg_salary desc

)

select 
skill_demand.skill_name, skill_demand.job_count, skill_based_on_salary.avg_salary
from skill_demand
inner join skill_based_on_salary 
ON skill_demand.skill_id = skill_based_on_salary.skill_id
order by skill_demand.job_count desc, skill_based_on_salary.avg_salary desc
limit 10;

/*
[
  {
    "skill_name": "sql",
    "job_count": "398",
    "avg_salary": "97237"
  },
  {
    "skill_name": "excel",
    "job_count": "256",
    "avg_salary": "87288"
  },
  {
    "skill_name": "python",
    "job_count": "236",
    "avg_salary": "101397"
  },
  {
    "skill_name": "tableau",
    "job_count": "230",
    "avg_salary": "99288"
  },
  {
    "skill_name": "r",
    "job_count": "148",
    "avg_salary": "100499"
  },
  {
    "skill_name": "power bi",
    "job_count": "110",
    "avg_salary": "97431"
  },
  {
    "skill_name": "sas",
    "job_count": "63",
    "avg_salary": "98902"
  },
  {
    "skill_name": "sas",
    "job_count": "63",
    "avg_salary": "98902"
  },
  {
    "skill_name": "powerpoint",
    "job_count": "58",
    "avg_salary": "88701"
  },
  {
    "skill_name": "looker",
    "job_count": "49",
    "avg_salary": "103795"
  }
]
*/