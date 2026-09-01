-- Create Power BI-friendly views
-- Fact view
CREATE OR REPLACE VIEW `meridian_bi.v_fact_aum_revenue_monthly` AS
SELECT
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
  fee_revenue_eur
FROM `meridian_bi.fact_aum_revenue_monthly`;

-- Model documentation view
   -- This one is useful for checking the business story directly in SQL.--
CREATE OR REPLACE VIEW `meridian_bi.v_aum_revenue_enriched` AS
SELECT
  d.full_date,
  d.year,
  d.quarter_name,
  d.year_month,

  fu.fund_name,
  fu.fund_promoter,
  fu.asset_class,
  fu.sub_asset_class,
  fu.share_class,

  dist.distributor_name,
  dist.distributor_type,
  dist.country_code,
  dist.tier,

  r.region_name,
  r.market_maturity,

  rm.rm_name,
  rm.seniority,

  f.opening_aum_eur,
  f.gross_subscriptions_eur,
  f.gross_redemptions_eur,
  f.net_subscriptions_eur,
  f.market_movement_eur,
  f.closing_aum_eur,
  f.avg_aum_eur,
  f.target_aum_eur,
  f.management_fee_bps,
  f.fee_revenue_eur

FROM `meridian_bi.fact_aum_revenue_monthly` f
JOIN `meridian_bi.dim_date` d
  ON f.date_key = d.date_key
JOIN `meridian_bi.dim_fund` fu
  ON f.fund_key = fu.fund_key
JOIN `meridian_bi.dim_distributor` dist
  ON f.distributor_key = dist.distributor_key
JOIN `meridian_bi.dim_region` r
  ON f.region_key = r.region_key
JOIN `meridian_bi.dim_relationship_manager` rm
  ON f.rm_key = rm.rm_key;

