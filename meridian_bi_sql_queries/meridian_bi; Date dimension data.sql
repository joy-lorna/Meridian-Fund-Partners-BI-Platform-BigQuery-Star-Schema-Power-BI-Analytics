-- =========================================================
-- DATE DIMENSION
-- 18 month-end dates from Jan 2024 to Jun 2025
-- =========================================================

INSERT INTO `project-f57ec015-00f5-4842-84d.meridian_bi.dim_date`
  (
    date_key,
    full_date,
    month_number,
    month_name,
    quarter,
    quarter_name,
    year,
    year_month,
    is_year_end)
SELECT
  CAST(FORMAT_DATE('%Y%m%d', month_end_date) AS INT64) AS date_key,
  month_end_date AS full_date,
  EXTRACT(MONTH FROM month_end_date) AS month_number,
  FORMAT_DATE('%B', month_end_date) AS month_name,
  EXTRACT(QUARTER FROM month_end_date) AS quarter,
  CONCAT('Q', CAST(EXTRACT(QUARTER FROM month_end_date) AS STRING))
    AS quarter_name,
  EXTRACT(YEAR FROM month_end_date) AS year,
  FORMAT_DATE('%Y-%m', month_end_date) AS year_month,
  EXTRACT(MONTH FROM month_end_date) = 12 AS is_year_end
FROM
  (
    SELECT
      LAST_DAY(DATE_ADD(DATE '2024-01-01', INTERVAL month_offset MONTH), MONTH)
        AS month_end_date
    FROM UNNEST(GENERATE_ARRAY(0, 17)) AS month_offset
  );

