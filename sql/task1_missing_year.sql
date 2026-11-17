-- Task 1: Count products with a missing year_added value
-- Output: single column `missing_year`

SELECT COUNT(*) AS missing_year
FROM products
WHERE year_added IS NULL
   OR TRIM(CAST(year_added AS TEXT)) IN ('', '-');
