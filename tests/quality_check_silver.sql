/*
====================================================================================================
Quality Checks
====================================================================================================
Script Purpose:
      This script performs various quality checks for data consistency, accuracy,
      and standardization across the 'silver' schemas. It includes checks for:
      - Null or duplicates primary keys.
      - Unwanted spaces in string fields.
      - Data standardization and consistency.
      - Invalid date ranges and orders.
      - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading silver.
    - Investigate anf resolve any discrepancies found dring the checks.
=====================================================================================================
*/


-- ====================================
-- checking 'Silver.crm_cust_info
-- ====================================

-- Checking For Nulls or Duplicate in Primary Key
-- Expectation: No Result

SELECT cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for unwanted spaces
-- Expectations: No Results
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

--Data Standardization & Consitency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info


-- ====================================
-- checking 'Silver.crm_sales_details
-- ====================================

-- Check for Invalid Dates
SELECT
NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

-- Check for Invalid Date Orders
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

--Check Data Consistenct: Between Sales, Quantity, and Price
--> Sales = Quantity * Price
--> Values must not be NULL, Zero, or negative

SELECT 
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price


-- ====================================
-- checking 'Silver.crm_cust_details
-- ====================================

-- Checking For Nulls or Duplicate in Primary Key
-- Expectation: No Result

SELECT cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for unwanted spaces
-- Expectations: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

--Data Standardization & Consitency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info



-- ====================================
-- checking 'Silver.crm_prd_info
-- ====================================

-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result

SELECT prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL

--Check for unwanted Spaces
-- Expectation: No Results
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE Prd_nm != TRIM(prd_nm)

-- check for NULLs or Negative NUmbeers
-- Expectaitons: No Results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & Consitency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Check for Invalid Date Orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- ====================================
-- checking 'Silver.erp_cust_az12
-- ====================================

-- Identifying Out-of-Range Dates
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standardization & Consistency
SELECT DISTINCT gen
FROM bronze.erp_cust_az12
