# DataCamp Associate Data Analyst in SQL: Grocery Store Sales

**Status: Passed.** This repo holds my solutions for the DataCamp **Associate Data Analyst in SQL** certification practical exam, written in SQL (PostgreSQL syntax).

The project is about a fictional US grocery chain called FoodYum. The company wants to keep products in stock across a range of prices in every category (produce, meat, dairy, bakery and snacks) while food costs go up. All the data sits in one table called `products`, with columns for product type, brand, weight, price, average units sold per month, year added and stock location.

## The four tasks

**Task 1: Count missing values.** Find out how many products are missing a `year_added` value, since a bug in the product system left some 2022 products without one.

**Task 2: Clean the data.** Build a clean version of the table without modifying the original. Missing text values become "Unknown", missing weight and price become the overall median, missing units sold become 0, and missing year becomes 2022.

**Task 3: Aggregate by group.** Return the minimum and maximum price for each product type.

**Task 4: Filter on conditions.** Return the meat and dairy products that sell more than ten units a month on average.

## My approach

Task 1 is a `COUNT(*)` with a `NULL` check. In Task 2 I used a CTE to parse and standardize every column first (trimming text, converting types with `CAST`, stripping stray characters with `REGEXP_REPLACE`), then a second CTE to calculate the medians with `PERCENTILE_CONT` before filling gaps. Computing the medians first means they are based only on real values, not on values I had already imputed. Tasks 3 and 4 reuse the same cleaning logic so every result is consistent with Task 2.

## Skills used

| Skill | Task |
|-------|------|
| Identifying missing values | 1 |
| Imputing with medians and constants | 2 |
| Converting data types | 2 |
| Cleaning text with string functions | 2 |
| Aggregating with `GROUP BY`, `MIN`, `MAX` | 3 |
| Filtering with `WHERE` and `IN` | 4 |
| Structuring queries with CTEs | 2 to 4 |

## Repository structure

```
sql/
  task1_missing_year.sql
  task2_clean_data.sql
  task3_min_max_price.sql
  task4_meat_dairy_filter.sql
README.md
LICENSE
```

## What I learned

The trickiest part was Task 2. I learned to calculate the medians before filling any gaps, so the imputed values do not influence the median itself. I also learned to check text columns for inconsistent values (extra spaces, mixed capitalization, placeholder characters) before trusting any grouping or filtering. Next time I would start every cleaning task by profiling each column’s distinct values first.

## Notes

The dataset and the original exam text belong to DataCamp, so they are not included in this repo. The queries are written for PostgreSQL.

## Author

Brianne Garilao | [LinkedIn](https://www.linkedin.com/in/briannegarilao/) | [GitHub](https://github.com/briannegarilao)
