-- Task 3: Minimum and maximum price for each product type
-- Uses the same cleaning logic as Task 2
-- Output columns: product_type, min_price, max_price

WITH parsed AS (
  SELECT
    product_id,
    CASE
      WHEN product_type IS NULL OR TRIM(product_type) IN ('', '-') THEN 'Unknown'
      ELSE INITCAP(TRIM(product_type))
    END AS product_type,
    CAST(NULLIF(REGEXP_REPLACE(CAST(price AS TEXT), '[^0-9.]', '', 'g'), '') AS NUMERIC) AS price
  FROM products
),
medians AS (
  SELECT CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS NUMERIC) AS median_price
  FROM parsed
),
clean AS (
  SELECT
    p.product_type,
    ROUND(COALESCE(p.price, m.median_price), 2) AS price
  FROM parsed p
  CROSS JOIN medians m
)
SELECT
  product_type,
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM clean
GROUP BY product_type
ORDER BY product_type;
