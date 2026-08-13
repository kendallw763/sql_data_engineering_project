/*
This query searches through job postings to find which skills are most commonly requested for remote Data Engineer roles.

It starts by looking at three connected tables: one with job posting details, one that links jobs to skills, and one with skill names. 

The query filters down to only jobs where the title is "Data Engineer" and the position allows working from home.

Then it counts how many times each skill appears across all those filtered job postings. 

The results are sorted so the most frequently mentioned skills appear first, and it only shows you the top 20 skills.

Essentially, it answers the question: "What are the 20 most in-demand skills for remote Data Engineer positions?"
*/
SELECT 
    sd.skills,
    COUNT(jpf.*) AS demand_count
FROM 
    job_postings_fact jpf
INNER JOIN 
    skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN 
    skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
        AND jpf.job_work_from_home = True 
GROUP BY    
    sd.skills
ORDER BY 
    demand_count DESC
LIMIT 20;

/*
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ python     │         1056 │
│ sql        │         1037 │
│ aws        │          717 │
│ spark      │          466 │
│ azure      │          442 │
│ snowflake  │          421 │
│ airflow    │          370 │
│ java       │          289 │
│ kafka      │          273 │
│ databricks │          250 │
│ redshift   │          243 │
│ scala      │          229 │
│ git        │          195 │
│ terraform  │          183 │
│ hadoop     │          177 │
│ gcp        │          176 │
│ nosql      │          169 │
│ pyspark    │          147 │
│ tableau    │          145 │
│ kubernetes │          143 │
└────────────┴──────────────┘
*/







