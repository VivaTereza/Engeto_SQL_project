CREATE TABLE t_Tereza_Hadamova_project_SQL_secondary_final AS
SELECT
    e.year,
    c.country,
    c.continent,
    e.GDP,
    e.population,
    c.avg_height,
    c.life_expectancy
FROM
    economies e
JOIN
    countries c ON e.country = c.country
WHERE
    c.continent = 'Europe';    