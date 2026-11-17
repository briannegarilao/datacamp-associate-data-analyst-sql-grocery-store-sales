-- Task 2: Clean the products table without modifying the original
-- Rules: text gaps -> 'Unknown', weight/price gaps -> overall median,
--        average_units_sold gaps -> 0, year_added gaps -> 2022
-- Output columns: product_id, product_type, brand, weight, price,
--                 average_units_sold, year_added, stock_location

WITH parsed AS (
  SELECT
    product_id,
    CASE
      WHEN product_type IS NULL OR TRIM(product_type) IN ('', '-') THEN 'Unknown'
      ELSE INITCAP(TRIM(product_type))
    END AS product_type,
    CASE
      WHEN brand IS NULL OR TRIM(brand) IN ('', '-') THEN 'Unknown'
      ELSE TRIM(brand)
    END AS brand,
    CAST(NULLIF(REGEXP_REPLACE(CAST(weight AS TEXT), '[^0-9.]', '', 'g'), '') AS NUMERIC) AS weight,
    CAST(NULLIF(REGEXP_REPLACE(CAST(price AS TEXT), '[^0-9.]', '', 'g'), '') AS NUMERIC) AS price,
    CAST(NULLIF(REGEXP_REPLACE(CAST(average_units_sold AS TEXT), '[^0-9.]', '', 'g'), '') AS NUMERIC) AS average_units_sold,
    CAST(NULLIF(REGEXP_REPLACE(CAST(year_added AS TEXT), '[^0-9.]', '', 'g'), '') AS NUMERIC) AS year_added,
    CASE
      WHEN stock_location IS NULL OR TRIM(stock_location) IN ('', '-') THEN 'Unknown'
      ELSE UPPER(TRIM(stock_location))
    END AS stock_location
  FROM products
),
medians AS (
  SELECT
    CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY weight) AS NUMERIC) AS median_weight,
    CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS NUMERIC) AS median_price
  FROM parsed
)
SELECT
  p.product_id,
  p.product_type,
  p.brand,
  ROUND(COALESCE(p.weight, m.median_weight), 2) AS weight,
  ROUND(COALESCE(p.price, m.median_price), 2) AS price,
  CAST(COALESCE(p.average_units_sold, 0) AS INTEGER) AS average_units_sold,
  CAST(COALESCE(p.year_added, 2022) AS INTEGER) AS year_added,
  p.stock_location
FROM parsed p
CROSS JOIN medians m
ORDER BY p.product_id;
