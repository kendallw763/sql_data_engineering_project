/*
The query pulls data from three connected tables: a jobs database containing salary information, 

a junction table that links specific jobs to their required skills, and a skills reference table. 

It filters to only look at positions with the job title "Data Engineer" that explicitly allow working from home.

It then groups all the job postings by skill and calculates two things for each skill: 

the median salary across all jobs requiring that skill, and the total number of job postings that mention it.

To ensure statistical reliability, it excludes any skills that appear in fewer than 100 job postings. 

This filters out niche or rarely-requested skills.

Finally, it ranks the remaining skills by median salary from highest to lowest and displays only the top 45. 

So the result shows you which specific skills command the highest median compensation for remote Data Engineer roles, 

among those skills that are frequently requested in the job market.

In essence: Which in-demand skills pay the most for remote Data Engineers?
*/


SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS skills_count
FROM 
    job_postings_fact jpf

INNER JOIN  
    skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
AND jpf.job_work_from_home  = True 
GROUP BY
    sd.skills
HAVING count (sd.skills) >= 100
order by 
    median_salary DESC
LIMIT 45;

/*
┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ skills_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ terraform  │      184000.0 │         3248 │
│ golang     │      184000.0 │          912 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ bitbucket  │      155000.0 │          478 │
│ django     │      155000.0 │          265 │
│ crystal    │      154224.0 │          129 │
│ atlassian  │      151500.0 │          249 │
│ c          │      151500.0 │          444 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ css        │      150000.0 │          262 │
│ ruby       │      150000.0 │          736 │
│ airflow    │      150000.0 │         9996 │
│   ·        │          ·    │           ·  │
│   ·        │          ·    │           ·  │
│   ·        │          ·    │           ·  │
│ visio      │      146500.0 │          105 │
│ kafka      │      145000.0 │         6415 │
│ outlook    │      140000.0 │          199 │
│ git        │      140000.0 │         4641 │
│ splunk     │      140000.0 │          251 │
│ pyspark    │      140000.0 │         4898 │
│ word       │      140000.0 │          650 │
│ pandas     │      140000.0 │         2929 │
│ go         │      140000.0 │         1997 │
│ spark      │      140000.0 │        12799 │
│ unity      │      138000.0 │          291 │
│ aws        │      137320.0 │        17823 │
│ scala      │      137290.0 │         6304 │
│ dynamodb   │      136000.0 │         1082 │
│ gcp        │      136000.0 │         6446 │
│ looker     │      136000.0 │         1574 │
│ mongodb    │      135750.0 │         3512 │
│ aurora     │      135500.0 │          423 │
│ snowflake  │      135500.0 │         8639 │
│ github     │      135000.0 │         1987 │
└────────────┴───────────────┴──────────────┘
  45 rows (40 shown)              3 columns
*/
