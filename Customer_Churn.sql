/*=========================================================
  CUSTOMER CHURN ANALYSIS
  Dataset: WA_Fn_UseC_Telco_Customer_Churn
=========================================================*/




/*=========================================================
  1. Overall Churn Rate
=========================================================*/

WITH churn_segments AS (
    SELECT
        Contract,
        COUNT(*) AS customers,
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned
    FROM WA_Fn_UseC_Telco_Customer_Churn
    GROUP BY Contract
)

SELECT *,
       ROUND(churned * 100.0 / customers,2) AS churn_rate
FROM churn_segments;

SELECT
    Contract,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
            SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
                / COUNT(*),
            2
    ) AS churn_rate
FROM WA_Fn_UseC_Telco_Customer_Churn
GROUP BY Contract
ORDER BY churn_rate DESC;

/*=========================================================
  2. Identify Primary Churn Drivers
=========================================================*/

WITH churn_drivers AS (

    -- Contract Type
    SELECT
        'Contract' AS factor,
        Contract AS segment,
        COUNT(*) AS customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
        ROUND(
                SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
                COUNT(*),
                2
        ) AS churn_rate
    FROM WA_Fn_UseC_Telco_Customer_Churn
    GROUP BY Contract

    UNION ALL

    -- Tech Support
    SELECT
        'Tech Support',
        TechSupport,
        COUNT(*),
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END),
        ROUND(
                SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
                COUNT(*),
                2
        )
    FROM WA_Fn_UseC_Telco_Customer_Churn
    GROUP BY TechSupport

    UNION ALL

    -- Internet Service
    SELECT
        'Internet Service',
        InternetService,
        COUNT(*),
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END),
        ROUND(
                SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
                COUNT(*),
                2
        )
    FROM WA_Fn_UseC_Telco_Customer_Churn
    GROUP BY InternetService

)

SELECT *
FROM churn_drivers
ORDER BY churn_rate DESC;


/*=========================================================
  3. Churn Rate by Contract & Tech Support
=========================================================*/

SELECT
    Contract,
    TechSupport,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
            SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
            COUNT(*),
            2
    ) AS churn_rate
FROM WA_Fn_UseC_Telco_Customer_Churn
GROUP BY
    Contract,
    TechSupport
HAVING COUNT(*) >= 50
ORDER BY churn_rate DESC;


/*=========================================================
  4. Revenue at Risk from Churned Customers
=========================================================*/

SELECT
    Contract,
    TechSupport,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(TotalCharges), 2) AS revenue_at_risk
FROM WA_Fn_UseC_Telco_Customer_Churn
WHERE Churn = 'Yes'
GROUP BY
    Contract,
    TechSupport
ORDER BY revenue_at_risk DESC;


/*=========================================================
  5. Churn by Customer Tenure
=========================================================*/

SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 Months'
        WHEN tenure <= 24 THEN '13-24 Months'
        WHEN tenure <= 48 THEN '25-48 Months'
        ELSE '49+ Months'
        END AS tenure_group,

    COUNT(*) AS customers,

    SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
                END
    ) AS churned_customers

FROM WA_Fn_UseC_Telco_Customer_Churn

GROUP BY
    CASE
        WHEN tenure <= 12 THEN '0-12 Months'
        WHEN tenure <= 24 THEN '13-24 Months'
        WHEN tenure <= 48 THEN '25-48 Months'
        ELSE '49+ Months'
        END

ORDER BY
    MIN(tenure);