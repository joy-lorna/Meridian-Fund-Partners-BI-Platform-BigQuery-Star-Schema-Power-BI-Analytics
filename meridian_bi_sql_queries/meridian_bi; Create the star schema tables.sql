-- =========================================================
-- MERIDIAN FUND PARTNERS S.A.
-- AUM & Revenue Analytics Dashboard
-- BigQuery Star Schema DDL
-- =========================================================

-- Optional clean rebuild
DROP TABLE IF EXISTS `project-f57ec015-00f5-4842-84d.meridian_bi.fact_aum_revenue_monthly`;
DROP TABLE IF EXISTS `project-f57ec015-00f5-4842-84d.meridian_bi.dim_distributor`;
DROP TABLE IF EXISTS `project-f57ec015-00f5-4842-84d.meridian_bi.dim_relationship_manager`;
DROP TABLE IF EXISTS `project-f57ec015-00f5-4842-84d.meridian_bi.dim_region`;
DROP TABLE IF EXISTS `project-f57ec015-00f5-4842-84d.meridian_bi.dim_fund`;
DROP TABLE IF EXISTS `project-f57ec015-00f5-4842-84d.meridian_bi.dim_date`;

-- =========================================================
-- DIM: DATE
-- Month-end grain
-- =========================================================
CREATE TABLE `project-f57ec015-00f5-4842-84d.meridian_bi.dim_date`(
  date_key INT64 NOT NULL,
  full_date DATE NOT NULL,
  month_number INT64 NOT NULL,
  month_name STRING NOT NULL,
  quarter INT64 NOT NULL,
  quarter_name STRING NOT NULL,
  year INT64 NOT NULL,
  year_month STRING NOT NULL,
  is_year_end BOOL NOT NULL,
  PRIMARY KEY(date_key) NOT ENFORCED);

-- =========================================================
-- DIM: FUND
-- =========================================================
CREATE TABLE `project-f57ec015-00f5-4842-84d.meridian_bi.dim_fund`(
  fund_key INT64 NOT NULL,
  fund_isin STRING NOT NULL,
  fund_name STRING NOT NULL,
  fund_promoter STRING NOT NULL,
  asset_class STRING NOT NULL,
  sub_asset_class STRING,
  fund_domicile STRING NOT NULL,
  base_currency STRING NOT NULL,
  share_class STRING NOT NULL,
  management_fee_bps NUMERIC NOT NULL,
  launch_date DATE,
  is_active BOOL NOT NULL,
  PRIMARY KEY(fund_key) NOT ENFORCED);

-- =========================================================
-- DIM: REGION
-- =========================================================
CREATE TABLE `project-f57ec015-00f5-4842-84d.meridian_bi.dim_region`(
  region_key INT64 NOT NULL,
  region_name STRING NOT NULL,
  market_maturity STRING,
  PRIMARY KEY(region_key) NOT ENFORCED);

-- =========================================================
-- DIM: RELATIONSHIP MANAGER
-- =========================================================
CREATE TABLE `project-f57ec015-00f5-4842-84d.meridian_bi.dim_relationship_manager`(
  rm_key INT64 NOT NULL,
  rm_id STRING NOT NULL,
  rm_name STRING NOT NULL,
  seniority STRING NOT NULL,
  coverage_regions STRING,
  aum_target_eur NUMERIC,
  hire_date DATE,
  is_active BOOL NOT NULL,
  PRIMARY KEY(rm_key) NOT ENFORCED);

-- =========================================================
-- DIM: DISTRIBUTOR
-- =========================================================
CREATE TABLE `project-f57ec015-00f5-4842-84d.meridian_bi.dim_distributor`(
  distributor_key INT64 NOT NULL,
  distributor_id STRING NOT NULL,
  distributor_name STRING NOT NULL,
  distributor_type STRING NOT NULL,
  country_code STRING NOT NULL,
  region_key INT64 NOT NULL,
  tier STRING NOT NULL,
  default_rm_key INT64,
  onboarding_date DATE,
  is_active BOOL NOT NULL,
  PRIMARY KEY(distributor_key) NOT ENFORCED,
  FOREIGN KEY(region_key)
  REFERENCES `project-f57ec015-00f5-4842-84d.meridian_bi.dim_region`(region_key)
  NOT ENFORCED,
  FOREIGN KEY(default_rm_key)
  REFERENCES `project-f57ec015-00f5-4842-84d.meridian_bi.dim_relationship_manager`(
    rm_key)
  NOT ENFORCED);

-- =========================================================
-- FACT: AUM & REVENUE MONTHLY
-- Grain: Fund x Distributor x Month
-- =========================================================
CREATE TABLE `project-f57ec015-00f5-4842-84d.meridian_bi.fact_aum_revenue_monthly`(
  fact_key INT64 NOT NULL,
  date_key INT64 NOT NULL,
  fund_key INT64 NOT NULL,
  distributor_key INT64 NOT NULL,
  region_key INT64 NOT NULL,
  rm_key INT64 NOT NULL,
  opening_aum_eur NUMERIC NOT NULL,
  closing_aum_eur NUMERIC NOT NULL,
  avg_aum_eur NUMERIC NOT NULL,
  target_aum_eur NUMERIC NOT NULL,
  gross_subscriptions_eur NUMERIC NOT NULL,
  gross_redemptions_eur NUMERIC NOT NULL,
  net_subscriptions_eur NUMERIC NOT NULL,
  market_movement_eur NUMERIC NOT NULL,
  management_fee_bps NUMERIC NOT NULL,
  fee_revenue_eur NUMERIC NOT NULL,
  created_at TIMESTAMP NOT NULL,
  PRIMARY KEY(fact_key) NOT ENFORCED,
  FOREIGN KEY(date_key)
  REFERENCES `project-f57ec015-00f5-4842-84d.meridian_bi.dim_date`(date_key)
  NOT ENFORCED,
  FOREIGN KEY(fund_key)
  REFERENCES `project-f57ec015-00f5-4842-84d.meridian_bi.dim_fund`(fund_key)
  NOT ENFORCED,
  FOREIGN KEY(distributor_key)
  REFERENCES `project-f57ec015-00f5-4842-84d.meridian_bi.dim_distributor`(
    distributor_key)
  NOT ENFORCED,
  FOREIGN KEY(region_key)
  REFERENCES `project-f57ec015-00f5-4842-84d.meridian_bi.dim_region`(region_key)
  NOT ENFORCED,
  FOREIGN KEY(rm_key)
  REFERENCES `project-f57ec015-00f5-4842-84d.meridian_bi.dim_relationship_manager`(
    rm_key)
  NOT ENFORCED)
  PARTITION BY RANGE_BUCKET(date_key, GENERATE_ARRAY(20240131, 20250630, 10000))
  CLUSTER BY fund_key, distributor_key, region_key, rm_key;

