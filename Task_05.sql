-- otazka 1

WITH salary_changes AS (
    SELECT
        year,
        code AS industry_branch_code,
        avg_value AS avg_salary,
        LAG(avg_value) OVER (PARTITION BY code ORDER BY year) AS prev_year_salary
    FROM
        primary_final
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
    

-- otazka 2

WITH milk_data AS (
    SELECT
        year,
        AVG(avg_value) AS avg_milk_price
    FROM
        primary_final
    WHERE
        data_type = 'price' AND code = 114201
    GROUP BY
        year
    ORDER BY
        year
),
   bread_data AS (
    SELECT
        year,
        AVG(avg_value) AS avg_bread_price
    FROM
        primary_final
    WHERE
        data_type = 'price' AND code = 111301
    GROUP BY
        year
    ORDER BY
        year
),
salary_data AS (
    SELECT
        year,
        AVG(avg_value) AS avg_salary
    FROM
        primary_final
 WITH yearly_changes AS (
    SELECT
        p.year,
        p.data_type,
        AVG(p.avg_value) AS avg_value,
        LAG(AVG(p.avg_value)) OVER (PARTITION BY p.data_type ORDER BY p.year) AS prev_year_avg_value,
        e.GDP,
        LAG(e.GDP) OVER (ORDER BY p.year) AS prev_year_GDP
    FROM
        t_Tereza_Hadamova_project_SQL_primary_final p
    LEFT JOIN
        t_Tereza_Hadamova_project_SQL_secondary_final e ON p.year = e.year AND e.country = 'Czech Republic'
    WHERE
        p.data_type IN ('price', 'salary')
    GROUP BY
        p.year, p.data_type, e.GDP
),
percentage_changes AS (
    SELECT
        year,
        data_type,
        ((avg_value - prev_year_avg_value) / prev_year_avg_value) * 100 AS year_to_year_percent_change,
        ((GDP - prev_year_GDP) / prev_year_GDP) * 100 AS gdp_year_to_year_percent_change
    FROM
        yearly_changes
    WHERE
        prev_year_avg_value IS NOT NULL AND prev_year_GDP IS NOT NULL
)
SELECT *
  FROM percentage_changes
--   WHERE 
--  	year_to_year_percent_change > 10
--   	gdp_year_to_year_percent_change > 10
ORDER BY data_type, year;
