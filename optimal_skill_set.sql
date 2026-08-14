/*
This SQL file finds the most valuable skills for remote Data Engineer jobs by filtering to Data Engineer postings,

excluding jobs without salary data, and keeping only remote roles. 

It joins the job postings table to the skill mapping table and the skill names table so each skill can be analyzed as a group. 

For each skill, it calculates how often it appears in job listings, the median salary of those listings, 

and a score that combines demand and pay using a logarithm. It then removes any skill that appears fewer than 100 times, 

sorts the remaining skills by the score in descending order, and shows the top 15 results. Basically, 

it ranks skills by how common they are and how well they pay, which helps identify the strongest remote Data Engineer skill set.

*/

SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 1) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND((LN(COUNT(jpf.*)) * MEDIAN(jpf.salary_year_avg))/1_000_000) AS optimal_score
FROM
    job_postings_fact jpf    
INNER JOIN
    skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
AND salary_year_avg IS NOT NULL 
AND jpf.job_work_from_home = True
GROUP BY 
    sd.skills
HAVING 
    COUNT(sjd.job_id ) >= 100
ORDER BY 
    optimal_score DESC
LIMIT 15;

/*
┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ python     │      135000.0 │         1133 │             7.0 │           1.0 │
│ r          │      134775.0 │          133 │             4.9 │           1.0 │
│ git        │      140000.0 │          208 │             5.3 │           1.0 │
│ mysql      │      130500.0 │          101 │             4.6 │           1.0 │
│ sql        │      130000.0 │         1128 │             7.0 │           1.0 │
│ databricks │      132750.0 │          266 │             5.6 │           1.0 │
│ flow       │      125500.0 │          107 │             4.7 │           1.0 │
│ bigquery   │      135000.0 │          123 │             4.8 │           1.0 │
│ redshift   │      130000.0 │          274 │             5.6 │           1.0 │
│ github     │      135000.0 │          127 │             4.8 │           1.0 │
│ aws        │      137320.3 │          783 │             6.7 │           1.0 │
│ hadoop     │      135000.0 │          198 │             5.3 │           1.0 │
│ docker     │      135000.0 │          144 │             5.0 │           1.0 │
│ go         │      140000.0 │          113 │             4.7 │           1.0 │
│ oracle     │      124500.0 │          109 │             4.7 │           1.0 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
*/
