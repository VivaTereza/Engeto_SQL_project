 WITH yearly_changes AS (
    SELECT
        year,
        data_type,
        AVG(avg_value) AS avg_value,
        LAG(AVG(avg_value)) OVER (PARTITION BY data_type ORDER BY year) AS prev_year_avg_value
    FROM
        t_Tereza_Hadamova_project_SQL_primary_final
    WHERE
        data_type IN ('price', 'salary')
    GROUP BY
        year, data_type
),

percentage_changes AS (
    SELECT
        year,
        data_type,
        ((avg_value - prev_year_avg_value) / prev_year_avg_value) * 100 AS year_to_year_percent_change
    FROM
        yearly_changes
    WHERE
        prev_year_avg_value IS NOT NULL
),
combined_changes AS (
    SELECT
        p.year,
        p.year_to_year_percent_change AS price_change,
        s.year_to_year_percent_change AS salary_change
    FROM
        (SELECT * FROM percentage_changes WHERE data_type = 'price') p
    JOIN
        (SELECT * FROM percentage_changes WHERE data_type = 'salary') s ON p.year = s.year
)
SELECT
    year,
    price_change,
    salary_change
FROM
    combined_changes

-- WHERE
--     price_change - salary_change > 10
-- if added, will show no results as there is not higher rise than 10%    
ORDER BY
    year; 