/*
=================================================================================================
Stored Procedur: Load Bronze Layer (Source -> Bronze)
=================================================================================================
Script Purpose:
    This stored procedur loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
     - Truncate the bronze tables before loading data.
     - Uses the 'BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:
    None.
This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
==================================================================================================
*/



CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

TRUNCATE TABLE bronze.crm_cust_info;


BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Public\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

TRUNCATE TABLE bronze.crm_prd_info;
BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\Public\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

TRUNCATE TABLE bronze.crm_sales_details;
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\Public\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

END
