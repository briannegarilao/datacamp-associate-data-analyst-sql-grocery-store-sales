-- Task 4: Meat and dairy products selling more than 10 units a month on average
-- Uses the same cleaning logic as Task 2
-- Output columns: product_id, price, average_units_sold

WITH parsed AS (
  SELECT
    product_id,
    CASE
      WHEN product_type IS NULL OR TRIM(product_type) IN ('', '-') THEN 'Unknown'
      ELSE INITCAP(TRIM(product_type))
    END AS product_type,
    CAST(NULLIF(REGEXP_REPLACE(CAST(price AS TEXT), '[^0-9.]', '', 'g'), '') AS NUMERIC) AS price,
    CAST(NULLIF(REGEXP_REPLACE(CAST(average_units_sold AS TEXT), '[^0-9.]', '', 'g'), '') AS NUMERIC) AS average_units_sold
  FROM products
),
medians AS (
  SELECT CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS NUMERIC) AS median_price
  FROM parsed
),
clean AS (
  SELECT
    p.product_id,
    p.product_type,
    ROUND(COALESCE(p.price, m.median_price), 2) AS price,
    CAST(COALESCE(p.average_units_sold, 0) AS INTEGER) AS average_units_sold
  FROM parsed p
  CROSS JOIN medians m
)
SELECT
  product_id,
  price,
  average_units_sold
FROM clean
WHERE product_type IN ('Meat', 'Dairy')
  AND average_units_sold > 10
ORDER BY product_id;
