-- Check every book has 18 months
SELECT
  fund_key,
  distributor_key,
  COUNT(*) AS month_count
FROM `meridian_bi.fact_aum_revenue_monthly`
GROUP BY
  fund_key,
  distributor_key
HAVING COUNT(*) <> 18;

-- Check opening AUM equals prior month closing AUM
WITH rollforward_check AS (
  SELECT
    fund_key,
    distributor_key,
    date_key,
    opening_aum_eur,
    LAG(closing_aum_eur) OVER (
      PARTITION BY fund_key, distributor_key
      ORDER BY date_key
    ) AS prior_month_closing_aum
  FROM `meridian_bi.fact_aum_revenue_monthly`
)

SELECT
  *
FROM rollforward_check
WHERE prior_month_closing_aum IS NOT NULL
  AND ABS(opening_aum_eur - prior_month_closing_aum) > 1;

-- Check closing AUM formula
SELECT
  fact_key,
  opening_aum_eur,
  gross_subscriptions_eur,
  gross_redemptions_eur,
  market_movement_eur,
  closing_aum_eur,
  opening_aum_eur
    + gross_subscriptions_eur
    - gross_redemptions_eur
    + market_movement_eur AS recalculated_closing_aum
FROM `meridian_bi.fact_aum_revenue_monthly`
WHERE ABS(
  closing_aum_eur -
  (
    opening_aum_eur
    + gross_subscriptions_eur
    - gross_redemptions_eur
    + market_movement_eur
  )
) > 1;

-- Check net subscriptions formula
SELECT
  fact_key,
  gross_subscriptions_eur,
  gross_redemptions_eur,
  net_subscriptions_eur,
  gross_subscriptions_eur - gross_redemptions_eur AS recalculated_net_subscriptions
FROM `meridian_bi.fact_aum_revenue_monthly`
WHERE ABS(
  net_subscriptions_eur -
  (gross_subscriptions_eur - gross_redemptions_eur)
) > 1;

-- Check fee revenue formula
SELECT
  fact_key,
  avg_aum_eur,
  management_fee_bps,
  fee_revenue_eur,
  avg_aum_eur * management_fee_bps / 10000 / 12 AS recalculated_fee_revenue
FROM `meridian_bi.fact_aum_revenue_monthly`
WHERE ABS(
  fee_revenue_eur -
  (avg_aum_eur * management_fee_bps / 10000 / 12)
) > 1;

-- Check for negative AUM
SELECT
  *
FROM `meridian_bi.fact_aum_revenue_monthly`
WHERE opening_aum_eur < 0
   OR closing_aum_eur < 0
   OR avg_aum_eur < 0;

-- Check orphan foreign keys
SELECT
  'date_key' AS issue_type,
  COUNT(*) AS issue_count
FROM `meridian_bi.fact_aum_revenue_monthly` f
LEFT JOIN `meridian_bi.dim_date` d
  ON f.date_key = d.date_key
WHERE d.date_key IS NULL

UNION ALL

SELECT
  'fund_key',
  COUNT(*)
FROM `meridian_bi.fact_aum_revenue_monthly` f
LEFT JOIN `meridian_bi.dim_fund` fu
  ON f.fund_key = fu.fund_key
WHERE fu.fund_key IS NULL

UNION ALL

SELECT
  'distributor_key',
  COUNT(*)
FROM `meridian_bi.fact_aum_revenue_monthly` f
LEFT JOIN `meridian_bi.dim_distributor` dist
  ON f.distributor_key = dist.distributor_key
WHERE dist.distributor_key IS NULL

UNION ALL

SELECT
  'region_key',
  COUNT(*)
FROM `meridian_bi.fact_aum_revenue_monthly` f
LEFT JOIN `meridian_bi.dim_region` r
  ON f.region_key = r.region_key
WHERE r.region_key IS NULL

UNION ALL

SELECT
  'rm_key',
  COUNT(*)
FROM `meridian_bi.fact_aum_revenue_monthly` f
LEFT JOIN `meridian_bi.dim_relationship_manager` rm
  ON f.rm_key = rm.rm_key
WHERE rm.rm_key IS NULL;