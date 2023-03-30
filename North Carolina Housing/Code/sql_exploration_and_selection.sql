------------------------------------------------------------------------
---------------------Data Selection / Reduction-------------------------
------------------------------------------------------------------------

--Commute as of 2019---------------------------------------------
CREATE OR REPLACE VIEW nc_housing_views.county_commute AS
  SELECT 
    Distinct County_Name                                AS county,
    _2019_Est_Avg_Travel_Time_To_Work__Minutes__ACS_    AS avg_commute_min,
    ROUND(100*(_2019___Drove_Car_Truck_Van_Alone__ACS_ + _2019___Carpooled_Car_Truck_Van__ACS_),1) AS method_vehicle_perc,
    ROUND(100*_2019___Working_from_Home__ACS_,1)        AS wfh_perc,
    ROUND(100*_2019___Public_Transp__ACS_,1)            AS method_pub_trans_perc,
    ROUND(100*_2019___Bicycle__ACS_,1)                  AS method_bike_perc,
    ROUND(100*_2019___Walked__ACS_,1)                   AS method_walked_perc,
    ROUND(100*_2019___Taxi__Motorcycle__Other__ACS_,1)  AS method_other_perc

  FROM `portfolio-project-380614.nc_housing.NC_county_commute` 
  WHERE County_Name IS NOT NULL

--Housing metrics-----------------------------------------------
CREATE OR REPLACE VIEW nc_housing_views.county_housing AS 
 SELECT
    core.county_name                           AS county,
    core.month_date_yyyymm                     AS date,
    core.active_listing_count,
    core.median_listing_price,
    core.median_days_on_market,
    core.median_square_feet                    AS median_sqft,
    core.median_listing_price_per_square_foot  AS median_price_per_sqft
  FROM `portfolio-project-380614.nc_housing.NC_county_core_metrics` core
  WHERE core.county_name LIKE "%, nc"
  ORDER BY core.county_name, core.month_date_yyyymm

--Demographics----------------------------------------------------------
CREATE OR REPLACE VIEW nc_housing_views.county_demographics AS
  SELECT
    Distinct County_Name AS county,
      ROUND(100*_2019_Est___Population_0_19__ACS_,1) AS age_0_19_perc,
    ROUND(100*(_2019_Est___Population_20_24__ACS_+_2019_Est___Population_25_34__ACS_),1) AS age_20_34_perc,
    ROUND(100*_2019_Est___Population_35_44__ACS_,1) AS age_35_44_perc,
    ROUND(100*_2019_Est___Population_45_54__ACS_,1) AS age_45_54_perc,
    ROUND(100*_2019_Est___Population_55_64__ACS_,1) AS age_55_64,
    ROUND(100*_2019_Est___Population_65___ACS_,1) AS age_65_up

  FROM `portfolio-project-380614.nc_housing.NC_county_demograph`
  ORDER BY County_Name

--Education---------------------------------------------------------
CREATE OR REPLACE VIEW nc_housing_views.county_education AS
  SELECT
    Distinct County_Name AS county,
    _2020_Average_SAT_score__1600_scale___NCDPI_              AS avg_SAT_score,
    _2019_Est_Education_Attainment____High_School_Grad___ACS_ AS highest_achieved_hs,
    _2019_Est_Education_Attainment_____Bachelors___ACS_       AS hgihest_achieved_bach
  FROM `portfolio-project-380614.nc_housing.NC_county_edu` 

--Employment----------------------------------------------------
CREATE OR REPLACE VIEW nc_housing_views.county_employment AS
  SELECT
    Distinct County_Name AS county,
    ROUND(100*Mar2022_Prelim___Unemployment_Rate__LAUS_,1)      AS unemp_rate_mar_2020,
    _2021_Employment_All_Industries__QCEW_ AS all_industries,
    _2021_Employment_Agriculture_Forestry_Fishing_Hunting__QCEW_ AS agriculture_forestry_fishing_hunting,
    _2021_Employment_Mining__QCEW_ AS mining,
    _2021_Employment_Utilities__QCEW_ AS utilities,
    _2021_Employment_Construction__QCEW_ AS construction,
    _2021_Employment_Manufacturing__QCEW_ AS manufacturing,
    _2021_Employment_Wholesale_Trade__QCEW_ AS wholesale_trade,
    _2021_Employment_Retail_Trade__QCEW_ AS retail_trade,
    _2021_Employment_Transportation_Warehousing__QCEW_ AS transportation_warehousing,
    _2021_Employment_Information__QCEW_ AS information,
    _2021_Employment_Finance_Insurance__QCEW_ AS finance_insurance,
    _2021_Employment_Real_Estate_Rental_Leasing__QCEW_ AS real_estate_rental_leasing,
    _2021_Employment_Professional_Technical_Services__QCEW_ AS professional_technical_services,
    _2021_Employment_Mgt_of_Companies_Enterprises__QCEW_ AS mgt_of_companies_enterprises,
    _2021_Employment_Administrative_Waste_Services__QCEW_ AS administrative_waste_services,
    _2021_Employment_Educational_Services__QCEW_ AS educational_services,
    _2021_Employment_Health_Care_Social_Assistance__QCEW_ AS health_care_social_assistance,
    _2021_Employment_Arts_Entertain_Recreation__QCEW_ AS arts_entertain_recreation,
    _2021_Employment_Accommodation_Food_Services__QCEW_ AS accommodation_food_services,
    _2021_Employment_Other_Services_Ex__Public_Admin__QCEW_ AS other_services_ex__public_admin,
    _2021_Employment_Public_Admin__QCEW_ AS public_admin,
    _2021_Employment_Unclassified__QCEW_ AS unclassified
  FROM `portfolio-project-380614.nc_housing.NC_county_employment`
  ORDER BY County_Name


--Income-------------------------------------------------------------
CREATE OR REPLACE VIEW nc_housing_views.county_income AS
SELECT
  Distinct County_Name AS county,
  _2019_Est_Median_Worker_Earnings__ACS_                          AS median_worker_inc_2019,
  _2020_Median_Household_Income__SAIPE_                           AS median_hh_income_2020,
  ROUND(100*_2020_Est___Pop__Income_Below_Poverty__SAIPE_,1)      AS pop_perc_below_poverty_202
 
FROM `portfolio-project-380614.nc_housing.NC_county_income`

--population growth---------------------------------------------------
CREATE OR REPLACE VIEW nc_housing_views.county_pop_predictions AS
SELECT
      County as county,
      Year as year,
      Population as population
    FROM `portfolio-project-380614.nc_housing.NC_county_pop_predictions`

--zillow-----------------------------------------------------
CREATE OR REPLACE VIEW nc_housing_views.zillow AS
  SELECT
    RegionName AS county,
    _2016_02_29,
    _2016_03_31,
    _2016_04_30,
    _2016_05_31,
    _2016_06_30,
    _2016_07_31,
    _2016_08_31,
    _2016_09_30,
    _2016_10_31,
    _2016_11_30,
    _2016_12_31,
    _2017_01_31,
    _2017_02_28,
    _2017_03_31,
    _2017_04_30,
    _2017_05_31,
    _2017_06_30,
    _2017_07_31,
    _2017_08_31,
    _2017_09_30,
    _2017_10_31,
    _2017_11_30,
    _2017_12_31,
    _2018_01_31,
    _2018_02_28,
    _2018_03_31,
    _2018_04_30,
    _2018_05_31,
    _2018_06_30,
    _2018_07_31,
    _2018_08_31,
    _2018_09_30,
    _2018_10_31,
    _2018_11_30,
    _2018_12_31,
    _2019_01_31,
    _2019_02_28,
    _2019_03_31,
    _2019_04_30,
    _2019_05_31,
    _2019_06_30,
    _2019_07_31,
    _2019_08_31,
    _2019_09_30,
    _2019_10_31,
    _2019_11_30,
    _2019_12_31,
    _2020_01_31,
    _2020_02_29,
    _2020_03_31,
    _2020_04_30,
    _2020_05_31,
    _2020_06_30,
    _2020_07_31,
    _2020_08_31,
    _2020_09_30,
    _2020_10_31,
    _2020_11_30,
    _2020_12_31,
    _2021_01_31,
    _2021_02_28,
    _2021_03_31,
    _2021_04_30,
    _2021_05_31,
    _2021_06_30,
    _2021_07_31,
    _2021_08_31,
    _2021_09_30,
    _2021_10_31,
    _2021_11_30,
    _2021_12_31,
    _2022_01_31,
    _2022_02_28,
    _2022_03_31,
    _2022_04_30,
    _2022_05_31,
    _2022_06_30,
    _2022_07_31,
    _2022_08_31,
    _2022_09_30,
    _2022_10_31,
    _2022_11_30,
    _2022_12_31,
    _2023_01_31,
    _2023_02_28
  FROM `portfolio-project-380614.nc_housing.zillow_data`
  WHERE State = "NC"
  ORDER BY RegionName


