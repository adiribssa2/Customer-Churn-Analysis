/*=========================================================
  DATA CLEANING
  Dataset: WA_Fn_UseC_Telco_Customer_Churn
=========================================================*/


/*=========================================================
  1. Preview the Dataset
=========================================================*/

SELECT *
FROM WA_Fn_UseC_Telco_Customer_Churn;


/*=========================================================
  2. Check for Duplicate Customer IDs
=========================================================*/

SELECT
    customerID,
    COUNT(*) AS duplicate_count
FROM WA_Fn_UseC_Telco_Customer_Churn
GROUP BY customerID
HAVING COUNT(*) > 1;


/*=========================================================
  3. Check for Missing Values
=========================================================*/

SELECT
    SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END) AS missing_customerID,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS missing_tenure,
    SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS missing_monthlycharges,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS missing_totalcharges,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS missing_churn
FROM WA_Fn_UseC_Telco_Customer_Churn;


/*=========================================================
  4. Check for Blank Values
=========================================================*/

SELECT *
FROM WA_Fn_UseC_Telco_Customer_Churn
WHERE
    TRIM(customerID) = ''
   OR TRIM(TotalCharges) = '';


/*=========================================================
  5. Validate Categorical Values
=========================================================*/

SELECT DISTINCT Contract
FROM WA_Fn_UseC_Telco_Customer_Churn;

SELECT DISTINCT TechSupport
FROM WA_Fn_UseC_Telco_Customer_Churn;

SELECT DISTINCT InternetService
FROM WA_Fn_UseC_Telco_Customer_Churn;

SELECT DISTINCT Churn
FROM WA_Fn_UseC_Telco_Customer_Churn;


/*=========================================================
  6. Check Numeric Ranges
=========================================================*/

SELECT
    MIN(tenure) AS min_tenure,
    MAX(tenure) AS max_tenure,
    MIN(MonthlyCharges) AS min_monthly_charge,
    MAX(MonthlyCharges) AS max_monthly_charge,
    MIN(TotalCharges) AS min_total_charge,
    MAX(TotalCharges) AS max_total_charge
FROM WA_Fn_UseC_Telco_Customer_Churn;