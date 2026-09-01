-- =========================================================
-- FACT TABLE SIMULATION
-- Meridian Fund Partners S.A.
-- BigQuery version
-- =========================================================

TRUNCATE
  TABLE `project-f57ec015-00f5-4842-84d.meridian_bi.fact_aum_revenue_monthly`;

-- Step 1: Create temporary Fund x Distributor book assignment
CREATE TEMP TABLE book_assignment
AS
SELECT
  ROW_NUMBER() OVER (ORDER BY d.distributor_key, f.fund_key) AS book_id,
  f.fund_key,
  d.distributor_key,
  d.region_key,
  d.default_rm_key AS rm_key,
  CAST(f.management_fee_bps AS FLOAT64) AS management_fee_bps,
  f.asset_class,
  CASE d.tier
    WHEN 'Strategic' THEN 40000000 + RAND() * 60000000
    WHEN 'Core' THEN 15000000 + RAND() * 25000000
    ELSE 4000000 + RAND() * 8000000
    END
    AS starting_aum,
  CASE d.tier
    WHEN 'Strategic' THEN 55000000 + RAND() * 60000000
    WHEN 'Core' THEN 20000000 + RAND() * 25000000
    ELSE 6000000 + RAND() * 8000000
    END
    AS target_aum
FROM `project-f57ec015-00f5-4842-84d.meridian_bi.dim_fund` f
CROSS JOIN `project-f57ec015-00f5-4842-84d.meridian_bi.dim_distributor` d
WHERE
  RAND() < CASE d.tier
    WHEN 'Strategic' THEN 0.75
    WHEN 'Core' THEN 0.55
    ELSE 0.35
    END;

-- Step 2: Roll each book forward for 18 months
INSERT INTO `project-f57ec015-00f5-4842-84d.meridian_bi.fact_aum_revenue_monthly`
  (
    fact_key,
    date_key,
    fund_key,
    distributor_key,
    region_key,
    rm_key,
    opening_aum_eur,
    closing_aum_eur,
    avg_aum_eur,
    target_aum_eur,
    gross_subscriptions_eur,
    gross_redemptions_eur,
    net_subscriptions_eur,
    market_movement_eur,
    management_fee_bps,
    fee_revenue_eur,
    created_at)
WITH RECURSIVE
  months AS (
    SELECT ROW_NUMBER() OVER (ORDER BY date_key) AS month_seq, date_key
    FROM `project-f57ec015-00f5-4842-84d.meridian_bi.dim_date`
  ),
  rolled AS (
    -- Month 1
    SELECT
      b.book_id,
      b.fund_key,
      b.distributor_key,
      b.region_key,
      b.rm_key,
      b.management_fee_bps,
      b.asset_class,
      b.target_aum,
      m.month_seq,
      m.date_key,
      b.starting_aum AS opening_aum,
      b.starting_aum
        * CASE b.asset_class
          WHEN 'Equity' THEN (RAND() - 0.45) * 0.060
          WHEN 'Multi-Asset' THEN (RAND() - 0.45) * 0.030
          WHEN 'Fixed Income' THEN (RAND() - 0.48) * 0.015
          ELSE (RAND() - 0.50) * 0.001
          END
          AS market_movement,
      b.starting_aum * (0.010 + RAND() * 0.030) AS gross_subscriptions,
      b.starting_aum * (0.008 + RAND() * 0.028) AS gross_redemptions
    FROM book_assignment b
    JOIN months m
      ON m.month_seq = 1
    UNION ALL
    -- Months 2 to 18
    SELECT
      r.book_id,
      r.fund_key,
      r.distributor_key,
      r.region_key,
      r.rm_key,
      r.management_fee_bps,
      r.asset_class,
      r.target_aum,
      m.month_seq,
      m.date_key,
      r.opening_aum + r.gross_subscriptions - r.gross_redemptions
        + r.market_movement AS opening_aum,
      (
        r.opening_aum + r.gross_subscriptions - r.gross_redemptions
        + r.market_movement)
        * CASE r.asset_class
          WHEN 'Equity' THEN (RAND() - 0.45) * 0.060
          WHEN 'Multi-Asset' THEN (RAND() - 0.45) * 0.030
          WHEN 'Fixed Income' THEN (RAND() - 0.48) * 0.015
          ELSE (RAND() - 0.50) * 0.001
          END
          AS market_movement,
      (
        r.opening_aum + r.gross_subscriptions - r.gross_redemptions
        + r.market_movement)
        * (0.010 + RAND() * 0.030) AS gross_subscriptions,
      (
        r.opening_aum + r.gross_subscriptions - r.gross_redemptions
        + r.market_movement)
        * (0.008 + RAND() * 0.028) AS gross_redemptions
    FROM rolled r
    JOIN months m
      ON m.month_seq = r.month_seq + 1
    WHERE r.month_seq < 18
  )
SELECT
  ROW_NUMBER() OVER (ORDER BY book_id, month_seq) AS fact_key,
  date_key,
  fund_key,
  distributor_key,
  region_key,
  rm_key,
  CAST(ROUND(opening_aum, 2) AS NUMERIC),
  CAST(
    ROUND(
      opening_aum + gross_subscriptions - gross_redemptions + market_movement,
      2)
    AS NUMERIC),
  CAST(
    ROUND(
      (
        opening_aum + (
          opening_aum + gross_subscriptions - gross_redemptions
          + market_movement))
        / 2,
      2)
    AS NUMERIC),
  CAST(ROUND(target_aum / 12 * month_seq, 2) AS NUMERIC),
  CAST(ROUND(gross_subscriptions, 2) AS NUMERIC),
  CAST(ROUND(gross_redemptions, 2) AS NUMERIC),
  CAST(ROUND(gross_subscriptions - gross_redemptions, 2) AS NUMERIC),
  CAST(ROUND(market_movement, 2) AS NUMERIC),
  CAST(ROUND(management_fee_bps, 2) AS NUMERIC),
  CAST(
    ROUND(
      (
        (
          opening_aum + (
            opening_aum + gross_subscriptions - gross_redemptions
            + market_movement))
        / 2)
        * management_fee_bps / 10000 / 12,
      2)
    AS NUMERIC),
  CURRENT_TIMESTAMP()
FROM rolled;

