WITH salary_changes AS (
    SELECT
        year,
        code AS industry_branch_code,
        avg_value AS avg_salary,
        LAG(avg_value) OVER (PARTITION BY code ORDER BY year) AS prev_year_salary
    FROM
        t_Tereza_Hadamova_project_SQL_primary_final
    WHERE
        data_type = 'salary'
)
SELECT
    year,
    industry_branch_code,
    avg_salary,
    prev_year_salary,
    CASE
        WHEN prev_year_salary IS NULL THEN null
        WHEN avg_salary > prev_year_salary THEN 'Increase'
        WHEN avg_salary < prev_year_salary THEN 'Decrease'
        ELSE 'No Change'
    END AS salary_trend
FROM
    salary_changes
ORDER BY
    industry_branch_code, year;
    

