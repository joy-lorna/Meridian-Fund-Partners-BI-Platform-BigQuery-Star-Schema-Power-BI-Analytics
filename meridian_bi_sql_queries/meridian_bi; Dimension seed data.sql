-- =========================================================

-- SEED DIMENSION DATA

-- Meridian Fund Partners S.A.

-- =========================================================
-- Insert statements for dim_region
INSERT INTO `project-f57ec015-00f5-4842-84d.meridian_bi.dim_region`
(region_key, region_name, market_maturity)
VALUES
(1, 'Benelux', 'Core'),
(2, 'DACH', 'Core'),
(3, 'France', 'Core'),
(4, 'Nordics', 'Growth'),
(5, 'Iberia', 'Growth'),
(6, 'Italy', 'Growth');

-- Insert statements for dim_relationship_manager
INSERT INTO `project-f57ec015-00f5-4842-84d.meridian_bi.dim_relationship_manager`
(rm_key, rm_id, rm_name, seniority, coverage_regions, aum_target_eur, hire_date, is_active)
VALUES
(1, 'RM-001', 'Élise Bertrand', 'Director', 'Benelux, France', 650000000, DATE '2014-03-01', TRUE),
(2, 'RM-002', 'Markus Weber', 'Director', 'DACH', 600000000, DATE '2015-06-15', TRUE),
(3, 'RM-003', 'Sofia Lindqvist', 'VP', 'Nordics', 350000000, DATE '2018-01-10', TRUE),
(4, 'RM-004', 'Giulia Romano', 'VP', 'Italy, Iberia', 380000000, DATE '2017-09-01', TRUE),
(5, 'RM-005', 'Thomas Hansen', 'Associate', 'Benelux', 220000000, DATE '2021-02-01', TRUE),
(6, 'RM-006', 'Claire Dupont', 'Associate', 'France, DACH', 240000000, DATE '2020-11-15', TRUE);

-- Insert statements for dim_distributor
INSERT INTO `project-f57ec015-00f5-4842-84d.meridian_bi.dim_distributor`
(distributor_key, distributor_id, distributor_name, distributor_type, country_code, region_key, tier, default_rm_key, onboarding_date, is_active)
VALUES
(1, 'DIST-001', 'Banque Privée du Nord', 'Private Bank', 'LU', 1, 'Strategic', 1, DATE '2012-01-15', TRUE),
(2, 'DIST-002', 'Vermogens Partners NL', 'IFA Network', 'NL', 1, 'Core', 5, DATE '2016-04-01', TRUE),
(3, 'DIST-003', 'Rheinland Vermögensverwaltung', 'Private Bank', 'DE', 2, 'Strategic', 2, DATE '2013-07-01', TRUE),
(4, 'DIST-004', 'Alpen Wealth AG', 'Private Bank', 'CH', 2, 'Core', 6, DATE '2018-10-01', TRUE),
(5, 'DIST-005', 'Société de Gestion Privée', 'Private Bank', 'FR', 3, 'Strategic', 1, DATE '2012-09-01', TRUE),
(6, 'DIST-006', 'Nordkapital Rådgivning', 'IFA Network', 'SE', 4, 'Growth', 3, DATE '2019-03-01', TRUE),
(7, 'DIST-007', 'Banca Patrimoni Milano', 'Private Bank', 'IT', 6, 'Core', 4, DATE '2017-05-15', TRUE),
(8, 'DIST-008', 'Iberia Wealth Advisors', 'IFA Network', 'ES', 5, 'Growth', 4, DATE '2020-01-15', TRUE);

-- Insert statements for dim_fund
INSERT INTO `project-f57ec015-00f5-4842-84d.meridian_bi.dim_fund`
(fund_key, fund_isin, fund_name, fund_promoter, asset_class, sub_asset_class, fund_domicile, base_currency, share_class, management_fee_bps, launch_date, is_active)
VALUES
(1, 'LU0000000011', 'Solene Global Equity Fund', 'Solene Asset Management', 'Equity', 'Global Equity', 'LU', 'EUR', 'R Acc EUR', 165, DATE '2013-01-01', TRUE),
(2, 'LU0000000012', 'Solene European Equity Fund', 'Solene Asset Management', 'Equity', 'European Equity', 'LU', 'EUR', 'R Acc EUR', 150, DATE '2013-01-01', TRUE),
(3, 'LU0000000013', 'Verity Emerging Markets Equity Fund', 'Verity Global Investors', 'Equity', 'Emerging Markets', 'LU', 'EUR', 'R Acc EUR', 195, DATE '2015-06-01', TRUE),
(4, 'LU0000000014', 'Nordholm Euro Corporate Bond Fund', 'Nordholm Capital', 'Fixed Income', 'EUR IG Credit', 'LU', 'EUR', 'R Dis EUR', 95, DATE '2014-03-01', TRUE),
(5, 'LU0000000015', 'Nordholm Global High Yield Bond Fund', 'Nordholm Capital', 'Fixed Income', 'Global High Yield', 'LU', 'EUR', 'R Dis EUR', 135, DATE '2016-09-01', TRUE),
(6, 'LU0000000016', 'Meridian Multi-Asset Balanced Fund', 'Meridian Fund Partners', 'Multi-Asset', 'Balanced 60/40', 'LU', 'EUR', 'R Acc EUR', 130, DATE '2017-01-01', TRUE),
(7, 'LU0000000017', 'Meridian Multi-Asset Conservative Fund', 'Meridian Fund Partners', 'Multi-Asset', 'Conservative', 'LU', 'EUR', 'R Acc EUR', 105, DATE '2017-01-01', TRUE),
(8, 'LU0000000018', 'Solene Euro Money Market Fund', 'Solene Asset Management', 'Money Market', 'EUR Short-Term MMF', 'LU', 'EUR', 'R Cap EUR', 35, DATE '2012-01-01', TRUE),
(9, 'LU0000000019', 'Verity Sustainable Equity Fund', 'Verity Global Investors', 'Equity', 'Global ESG Equity', 'LU', 'EUR', 'R Acc EUR', 175, DATE '2019-11-01', TRUE),
(10, 'LU0000000020', 'Nordholm Short Duration Bond Fund', 'Nordholm Capital', 'Fixed Income', 'Short Duration', 'LU', 'EUR', 'R Dis EUR', 80, DATE '2018-04-01', TRUE);
