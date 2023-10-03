CREATE TABLE t_Tereza_Hadamova_project_SQL_primary_final AS
SELECT
    'salary' AS data_type,
    p.payroll_year AS year,
    p.industry_branch_code AS code,
    AVG(p.value) AS avg_value
FROM
    czechia_payroll p
WHERE value_type_code = 5958
  AND calculation_code = 100
GROUP BY
    p.payroll_year, p.industry_branch_code

UNION ALL

SELECT
    'price' AS data_type,
    YEAR(pr.date_from) AS year,
    pc.code AS code,
    AVG(pr.value) AS avg_value
FROM
    czechia_price pr
JOIN
    czechia_price_category pc ON pr.category_code = pc.code
GROUP BY
    YEAR(pr.date_from), pc.code;
       