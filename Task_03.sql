WITH yearly_price_changes AS (
    SELECT
        code AS category_code,
        year,
        AVG(avg_value) AS avg_price,
        LAG(AVG(avg_value)) OVER (PARTITION BY code ORDER BY year) AS prev_year_avg_price
    FROM (
        SELECT
            code,
            year,
            avg_value
        FROM
            t_Tereza_Hadamova_project_SQL_primary_final
        WHERE
            data_type = 'price'
    ) sub
    GROUP BY
        code, year
),

percentage_changes AS (
    SELECT
        category_code,
        year,
        ((avg_price - prev_year_avg_price) / prev_year_avg_price) * 100 AS year_to_year_percent_change
    FROM
        yearly_price_changes
    WHERE
        prev_year_avg_price IS NOT NULL
)

SELECT
    category_code,
    AVG(year_to_year_percent_change) AS avg_year_to_year_percent_change
FROM
    percentage_changes
GROUP BY
    category_code
ORDER BY
    avg_year_to_year_percent_change ASC;
    
 