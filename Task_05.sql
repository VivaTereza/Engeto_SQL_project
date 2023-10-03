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
