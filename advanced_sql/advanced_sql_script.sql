select * FROM company_dim limit 100;
select * FROM skills_dim;
select * FROM job_postings_fact limit 100;
select * FROM skills_job_dim;



select 
job_title_short,
job_location,
job_posted_date
from job_postings_fact
limit 10;

select 
job_title_short,
job_location,
job_posted_date::date as date_posted
from job_postings_fact
order by date_posted desc
limit 10;

select
job_title_short,
job_location,
job_posted_date at time zone 'UTC' at time zone 'EST'
from job_postings_fact
limit 10;


select 
job_title_short,
job_location,
extract(MONTH from job_posted_date) as month_posted,
extract(YEAR from job_posted_date) as year_posted
from job_postings_fact
limit 100;


select
count(job_id) as job_count,
extract (MONTH from job_posted_date) as month_posted
from job_postings_fact
where job_title_short = 'Data Analyst'
group by month_posted
order by job_count desc;

-- For January
CREATE TABLE january_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- For February
CREATE TABLE february_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- For March
CREATE TABLE march_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

select job_posted_date
from march_jobs
limit 10;

select distinct job_schedule_type
from job_postings_fact;


select
job_schedule_type,
avg(salary_year_avg) as year_salary,
avg(salary_hour_avg) as hour_salary

from job_postings_fact
where job_posted_date::date > '2023-06-01'
group by job_schedule_type 
order by job_schedule_type;

select
count(job_id) as job_count,
extract (MONTH from job_posted_date at time zone 'UTC' at time zone 'America/New_York') as month_posted
from job_postings_fact
group by month_posted
order by month_posted;

select *
from company_dim
limit 10;

select *
from job_postings_fact
limit 10;

select
company_dim.name as company_name,
-- job_postings_fact.job_health_insurance as health_insurance,
count(job_postings_fact.job_id) as job_count

from job_postings_fact
right join company_dim 
on job_postings_fact.company_id = company_dim.company_id

where extract(quarter from job_postings_fact.job_posted_date) = 2 and job_postings_fact.job_health_insurance = 'true'

group by company_name

order by job_count desc;




select
--job_id,
job_location,
case
when job_location = 'Anywhere' then  'Remote'
when job_location = 'Boston, MA' then 'Local'
else 'Onsite'
end as location_type,
count(job_id) as job_count

from job_postings_fact
where job_title_short = 'Data Analyst'
group by location_type, job_location
order by job_count desc, job_location desc;


select
-- job_id,
job_location,
job_title_short,
case
when job_location = 'Anywhere' then  'Remote'
when job_location = 'Boston, MA' then 'Local'
else 'Onsite'
end as location_type,
count(job_id) as job_count
from job_postings_fact
--where job_title_short = 'Data Analyst'
group by job_location,job_title_short
order by  job_title_short, job_location;



select
job_id,
job_title,
salary_year_avg,
case
when salary_year_avg >= 100000 then 'high salary'
when salary_year_avg>=60000 and salary_year_avg < 100000 then 'Standard salary'
else 'low salary'
end as salary_category
from job_postings_fact
where job_title_short = 'Data Analyst' and salary_year_avg is not null
order by salary_year_avg desc;


select *
from job_postings_fact
limit 10;

select 
count(distinct company_id) as company_count,
case
when job_work_from_home = 'true' then 'Onsite'
else 'Remote'
end as work_type

from job_postings_fact
group by work_type
order by company_count desc;


select
job_id,
salary_year_avg,

case
when job_title ilike '%Senior%' then 'Senior'
when job_title ilike '%Manager%' or job_title ilike '%Lead%' then 'Lead/Manager'
when job_title ilike '%Junior%' or job_title ilike '%Entry%' then 'Junior/Entry'
else 'Not Specified'
end as experience_level,

case
when job_work_from_home = 'true' then 'Yes'
else 'No'
end as remote_option

from job_postings_fact
where salary_year_avg is not null
order by job_id;



--  SUBQUERY EXAMPLE
select job_posted_date, job_title_short, job_location
from (

select *
from job_postings_fact
where extract(month from job_posted_date) = 1


) as january_jobs;

-- CTE EXAMPLE
with january_jobs as (

    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 1

)

select job_posted_date
from january_jobs;

select *
from job_postings_fact
limit 10;

select
name
from company_dim
where company_id in(
    select company_id
    from job_postings_fact
    where job_no_degree_mention = true
);

select 
distinct company_dim.name as company_name
from company_dim 
inner join job_postings_fact
on company_dim.company_id = job_postings_fact.company_id
where job_postings_fact.job_no_degree_mention = true;

select
name , company_id
from company_dim
where company_id in(

select company_id
from job_postings_fact
where job_no_degree_mention = true
)
order by name;



with company_job_counts as (
select
company_id,
count(job_id) as job_count
from job_postings_fact
group by company_id
)

select
company_dim.name as company_name,
company_job_counts.job_count as job_countts
from company_dim

left join company_job_counts on company_dim.company_id= company_job_counts.company_id
order by job_countts desc;





select
company_dim.name as company_name,
count(job_postings_fact.job_id) as job_count
from job_postings_fact
right join company_dim
on job_postings_fact.company_id = company_dim.company_id
group by company_name
order by job_count Desc;

select *
from skills_dim
limit 10;


select *
from skills_job_dim
limit 10;


select *
from job_postings_fact
limit 10;

select
skills_dim.skill_id as skill_id,
skills_dim.skills as skill_name,
count(job_postings_fact.job_id) as job_count
from skills_dim
left join skills_job_dim 
on skills_dim.skill_id= skills_job_dim.skill_id
left join job_postings_fact
on skills_job_dim.job_id=job_postings_fact.job_id
where job_postings_fact.job_work_from_home=True 
group by skills_dim.skills, skills_dim.skill_id
order by job_count desc
limit 5;


with remote_job_skills as(
select

skills_job_dim.skill_id as skill_id, 
count(job_postings_fact.job_id) as skill_count
from skills_job_dim
inner join job_postings_fact 
on skills_job_dim.job_id= job_postings_fact.job_id
where job_postings_fact.job_work_from_home=True
group by skills_job_dim.skill_id

)

select remote_job_skills.skill_id, job, remote_job_skills.skill_count
from remote_job_skills
inner join skills_dim
on remote_job_skills.skill_id= skills_dim.skill_id




with job_id_count as(
select
skills_job_dim.skill_id as skill_ID,
count(job_postings_fact.job_id) job_count
from skills_job_dim 
inner join job_postings_fact
on skills_job_dim.job_id=job_postings_fact.job_id
group by skills_job_dim.skill_id
)

select
skills_dim.skills,
job_id_count.job_count
from job_id_count
inner join skills_dim
on job_id_count.skill_ID = skills_dim.skill_id
order by job_id_count.job_count Desc
limit 5


select
skills_dim.skills, count(skills_job_dim.job_id) as job_count
from skills_dim
inner join skills_job_dim
on skills_dim.skill_id=skills_job_dim.skill_id
group by skills_dim.skills
order by job_count desc
limit 5;


select
skills_dim.skills
from skills_dim
inner join (
select count(skills_job_dim.job_id) as job_count, skills_job_dim.skill_id
from skills_job_dim
group by skills_job_dim.skill_id
order by job_count desc
limit 5
) as result_set on
skills_dim.skill_id= result_set.skill_id
order by result_set.job_count desc;


select *
from job_postings_fact
limit 100;

select *
from company_dim
limit 10;
----------------------------------



select 
company_job_count.company_name, company_job_count.job_count,
case
when company_job_count.job_count<10 then 'Small'
when company_job_count.job_count between 10 and 50 then 'Medium'
else 'Large'
end as company_category

from (
select
company_dim.name as company_name,
count(job_postings_fact.job_id) as job_count
from company_dim
inner join job_postings_fact
on
company_dim.company_id=job_postings_fact.company_id
group by company_name
order by job_count 
) 
as company_job_count;

------------------------------------------------------------------------



select company_avg.company_name, company_avg.company_avg_salary,(select avg(salary_year_avg) from job_postings_fact) as AVG_salary

from(
select
company_dim.name as company_name, avg(job_postings_fact.salary_year_avg) as company_avg_salary
from
company_dim
inner join job_postings_fact
on company_dim.company_id=job_postings_fact.company_id
where job_postings_fact.salary_year_avg is not null
group by company_name) as company_avg

where company_avg.company_avg_salary > (select avg(salary_year_avg) from job_postings_fact);

select
avg(salary_year_avg) 
from job_postings_fact;

select *
from job_postings_fact
limit 10;


select
company_dim.name as company_name,
count(distinct job_postings_fact.job_title) as dis_job_title_count
from company_dim
inner join job_postings_fact on
company_dim.company_id= job_postings_fact.company_id
group by company_name
order by dis_job_title_count desc;


with job_title_c as (

select company_id,
count (distinct job_title) as job_title_count
from job_postings_fact
group by company_id

)

select job_title_c.job_title_count, company_dim.name
from job_title_c
inner join company_dim
on
job_title_c.company_id=company_dim.company_id

order by job_title_c.job_title_count desc;



with country_avg_salary as(
select
job_country,
avg (salary_year_avg) as salary_avg
from job_postings_fact
where salary_year_avg is not null
group by job_country
)

select job_country, salary_avg,
case
when salary_avg> (select avg(salary_year_avg)from job_postings_fact) then 'Above Average'
else 'Below Average'
end as salary_category
from country_avg_salary;

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

with country_avg_salary as(
select
job_country,
avg (salary_year_avg) as salary_avg
from job_postings_fact
where salary_year_avg is not null
group by job_country
)

select
job_postings_fact.job_id, job_postings_fact.salary_year_avg, 
extract(month from job_posted_date) as job_month,
company_dim.name as company_name,
country_avg_salary.job_country, country_avg_salary.salary_avg,

case
when job_postings_fact.salary_year_avg> country_avg_salary.salary_avg then 'Above Average'
else 'Below Average'
end as salary_category
from job_postings_fact
inner join country_avg_salary
on job_postings_fact.job_country= country_avg_salary.job_country
inner join company_dim
on job_postings_fact.company_id = company_dim.company_id
--where job_postings_fact.salary_year_avg is not null
order by job_postings_fact.salary_year_avg desc nulls last;


-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

with country_avg_salary as(
select
job_country,
avg (salary_year_avg) as salary_avg
from job_postings_fact
where salary_year_avg is not null
group by job_country
)

select
job_postings_fact.job_id, job_postings_fact.salary_year_avg, 
extract(month from job_posted_date) as job_month,
company_dim.name as company_name,
country_avg_salary.job_country, country_avg_salary.salary_avg,

case
when job_postings_fact.salary_year_avg> country_avg_salary.salary_avg then 'Above Average'
else 'Below Average'
end as salary_category
from job_postings_fact
inner join country_avg_salary
on job_postings_fact.job_country= country_avg_salary.job_country
inner join company_dim
on job_postings_fact.company_id = company_dim.company_id
where job_postings_fact.salary_year_avg> country_avg_salary.salary_avg
order by job_postings_fact.salary_year_avg desc nulls last;


---------------------------------------------------------------------------
---------------------------------------------------------------------------

select *
from skills_dim
where skill_id is null; -- skill_id, skills

select *
from skills_job_dim -- job_id, skill_id
where skill_id is null
;

select *
from company_dim;-- company_id, name

select *
from job_postings_fact -- job_id, company_id
limit 10;

----------------------------------------------------------------------------
----------------------------------------------------------------------------


with skill_count_per_company as (
select
company_dim.name as company_name, count( distinct skills_job_dim.skill_id) as unique_skills
from company_dim
left join job_postings_fact
on company_dim.company_id= job_postings_fact.company_id
left join skills_job_dim
on job_postings_fact.job_id=skills_job_dim.job_id
-- where skills_job_dim.skill_id is not null
group by company_name
order by unique_skills desc
),


max_salary_per_company as(
select
company_dim.name as company_name, max(job_postings_fact.salary_year_avg) as highest_salary
from
company_dim
left join
job_postings_fact
on company_dim.company_id= job_postings_fact.company_id
left join skills_job_dim
on job_postings_fact.job_id= skills_job_dim.job_id
where skills_job_dim.skill_id is not null
group by company_name
order by highest_salary desc nulls last
)

select
skill_count_per_company.company_name, skill_count_per_company.unique_skills,
max_salary_per_company.highest_salary
from
skill_count_per_company
left join max_salary_per_company
on skill_count_per_company.company_name= max_salary_per_company.company_name;


----------------------------------------------------------------------------
----------------------------------------------------------------------------


select
job_title_short, company_id, job_location, job_posted_date
from january_jobs
UNION all
SELECT 
	job_title_short,
	company_id,
	job_location,job_posted_date
FROM
	february_jobs

UNION all

SELECT 
	job_title_short,
	company_id,
	job_location,job_posted_date
FROM
	march_jobs;



-- Select job postings with salary information
(
SELECT 
    job_id, 
    job_title, 
    'With Salary Info' AS salary_info  -- Custom field indicating salary info presence
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL  
)
UNION ALL
 -- Select job postings without salary information
(
SELECT 
    job_id, 
    job_title, 
    'Without Salary Info' AS salary_info  -- Custom field indicating absence of salary info
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NULL AND salary_hour_avg IS NULL 
)
ORDER BY 
    salary_info DESC, 
    job_id; 



with quarter_data as(
select
job_id, job_title_short, job_location, job_via, salary_year_avg, job_posted_date::date
from january_jobs
where january_jobs.salary_year_avg>70000
UNION all
SELECT job_id, job_title_short, job_location, job_via, salary_year_avg, job_posted_date::date
FROM
	february_jobs
where february_jobs.salary_year_avg>70000
UNION all

SELECT 
	job_id, job_title_short, job_location, job_via, salary_year_avg, job_posted_date::date
FROM
	march_jobs

where march_jobs.salary_year_avg>70000

)

select quarter_data.job_id, quarter_data.job_title_short, quarter_data.job_location, quarter_data.job_via, skills_dim.skills, skills_dim.type
from quarter_data
left join skills_job_dim
on quarter_data.job_id= skills_job_dim.job_id
left join skills_dim
on skills_job_dim.skill_id= skills_dim.skill_id
order by quarter_data.job_id;


select
skill_id,
count(job_id) as job_count
from skills_job_dim
group by skill_id;


with quarter_jobs as (
select *
from january_jobs

union all

select *
from february_jobs

union all

select *
from march_jobs

)

select skills_dim.skills, count(quarter_jobs.job_id) as job_count, extract (month from quarter_jobs.job_posted_date) as month_posted, extract (year from quarter_jobs.job_posted_date) as year_posted
from quarter_jobs
left join skills_job_dim
on quarter_jobs.job_id= skills_job_dim.job_id
left join skills_dim
on skills_job_dim.skill_id= skills_dim.skill_id
where skills_dim.skills is not null
group by skills_dim.skills, month_posted, year_posted
order by job_count desc;
