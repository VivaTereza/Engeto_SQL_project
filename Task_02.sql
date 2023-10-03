WITH milk_data AS (
    SELECT
        year,
        AVG(avg_value) AS avg_milk_price
    FROM
        t_Tereza_Hadamova_project_SQL_primary_final
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
        t_Tereza_Hadamova_project_SQL_primary_final
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
        t_Tereza_Hadamova_project_SQL_primary_final
    WHERE
        data_type = 'salary'
    GROUP BY
        year
    ORDER BY
        year
)
SELECT
    s.year,
    s.avg_salary / m.avg_milk_price AS liters_of_milk,
    s.avg_salary / b.avg_bread_price AS kilograms_of_bread
FROM
    salary_data s
JOIN
    milk_data m ON s.year = m.year

JOIN
    bread_data b ON s.year = b.year
ORDER BY
    s.year;
 