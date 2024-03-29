
-------------------------------------- TABLE AUDIT QUERIES----------------------------------
-------------------------------------------------------------------------------------------
--All tasks using that table & how often run in last n days

SELECT
    DATE(A.COMPLETED_TIME) AS RUN_DATE,
    A.NAME AS TASK_NAME,
    B.TABLE_NAME AS TABLE_NAME,
    COUNT(DISTINCT A.QUERY_ID) AS TASK_RUNS
FROM
    TABLE(
        INFORMATION_SCHEMA.TASK_HISTORY(RESULT_LIMIT => 10000)
    ) A --TO GET TASK_HISTORY DATA
    INNER JOIN INFORMATION_SCHEMA.TABLES B -- TO GET TABLE CATALOG
    ON CONTAINS(A.QUERY_TEXT, 'ACI_O2_DIM') -- LOOKUP THE TABLE NAME IN THE TASK HISTORY QUERY TEXT FIELD
WHERE
    B.TABLE_NAME = 'ACI_O2_DIM' -- PASS OUR TABLE TO LOOKUP THE TABLE NAME INSIDE THE TABLE CATALOG
    AND A.QUERY_ID IS NOT NULL --WE WANT QUERY_ID NOT NULLS ONLY -- IF THEY'RE NULLS IT MEANS IS A SCHEDULE TASK (YET TO START)
    AND RUN_DATE >= DATEADD(DAY, -2, CURRENT_TIMESTAMP()) --FOR THE LAST 2 DAYS
GROUP BY
    RUN_DATE,
    TASK_NAME,
    TABLE_NAME
ORDER BY
    TASK_RUNS DESC;

    
    --All Procedures using that table & how often run in last n days
    
    --*WE USE QUERY HISTORY VIEW TO VALIDATE IF THE QUERY TEXT CONTAINS THE TABLE NAME AND STORE PROCEDURE NAME AND ALSO IF USER_NAME IS SYSTEM(IF DIFFERENT THAN SYSTEM IS NOT AN SP)

    SELECT
    DATE(A.END_TIME) AS RUN_DATE,
    C.PROCEDURE_NAME AS PROCEDURE_NAME,
    B.TABLE_NAME AS TABLE_NAME,
    COUNT(DISTINCT A.QUERY_ID) AS PROCEDURE_RUNS
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_CXA_WH',
            RESULT_LIMIT => 10000
        )
    ) A -- TO GET QUERY HISTORY DATA FROM ADP_CXA_WH --USE OTHER WAREHOUSE AS NEEDED
    INNER JOIN INFORMATION_SCHEMA.TABLES B -- TO GET TABLE CATALOG DATA
    ON CONTAINS(A.QUERY_TEXT, 'ACI_SCORING_SALESPLAY') -- LOOKUP FOR THE TABLE NAME INSIDE THE QUERY HISTORY TEXT FIELD
    INNER JOIN INFORMATION_SCHEMA.PROCEDURES C -- TO GET STORE PROCEDURES CATALOG DATA
    ON CONTAINS (A.QUERY_TEXT, C.PROCEDURE_NAME) -- LOOKUP THE STORE PROCEDURE NAME INSIDE THE QUERY HISTORY TEXT (IF THERE IS A CALL... AN SP SHOULD BE THERE)
WHERE
    B.TABLE_NAME = 'ACI_SCORING_SALESPLAY' -- PASS OUR TABLE
    AND A.QUERY_ID IS NOT NULL -- WE JUST WANT QUERY_ID NOT NULLS -- IF NULLS IT MEANS IS A SCHEDULE TASK YET TO START
    AND A.USER_NAME = 'SYSTEM' -- STORED PROCEDURES USES SYSTEM AS USER_NAME
    AND RUN_DATE >= DATEADD(DAY, -2, CURRENT_TIMESTAMP()) -- WE WANT FOR 2 DAYS, WE CAN CHANGE IT
GROUP BY
    PROCEDURE_NAME,
    TABLE_NAME,
    RUN_DATE
ORDER BY
    PROCEDURE_RUNS DESC;

    
--How many times that table has been queried in last n days
    
SELECT
    DATE(A.END_TIME) AS RUN_DATE,
    B.TABLE_NAME AS TABLE_NAME,
    B.TABLE_SCHEMA,
    COUNT(DISTINCT A.QUERY_ID) AS QUERY_RUNS
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY(RESULT_LIMIT => 10000)
    ) A -- TO GET QUERY HISTORY DATA FROM ADP_CXA_WH --USE OTHER WAREHOUSE AS NEEDED OR UNION ALL
    INNER JOIN INFORMATION_SCHEMA.TABLES B --TO GET TABLE CATALOG DATA
    ON CONTAINS(A.QUERY_TEXT, 'ACI_O2_DIM') -- LOOKUP FOR THE TABLE NAME INSIDE THE QUERY HISTORY TEXT
    AND A.SCHEMA_NAME = B.TABLE_SCHEMA -- ALSO WHERE SCHEMA ARE EQUAL IN BOTH TABLES
WHERE
    B.TABLE_NAME = 'ACI_O2_DIM' -- PASS OUR TABLE OR LIST OF TABLES USING IN (TABLE1, TABLE 2...)
    AND A.QUERY_ID IS NOT NULL -- WE JUST WANT QUERY_ID NOT NULLS -- IF NULLS IT MEANS IS A SCHEDULE TASK YET TO START
    AND A.END_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP()) -- WE WANT FOR 2 DAYS, WE CAN CHANGE IT
GROUP BY
    RUN_DATE,
    TABLE_NAME,
    B.TABLE_SCHEMA
ORDER BY
    QUERY_RUNS DESC;

    
--Last altered date

--For all tables in PUBLIC AND PRIVATE SCHEMAS

SELECT
    TABLE_NAME,
    TABLE_SCHEMA,
    DATE(LAST_ALTERED) AS LAST_ALTERED_DATE,
    CASE 
        WHEN DATE(LAST_ALTERED) = DATE(CURRENT_TIMESTAMP()) THEN 'Updated today'
        ELSE 'Not Updated today' END AS TABLE_DAILY_STATUS
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    LAST_ALTERED > DATEADD(DAY, -2, CURRENT_TIMESTAMP)
    AND TABLE_SCHEMA IN ('AKP_PRIVATE', 'AKP_PUBLIC')
    AND TABLE_TYPE = 'BASE TABLE' -- BASE TABLE MEANS PERMANENT OR TRANSIENT
ORDER BY
    LAST_ALTERED_DATE DESC;

    
--For selective tables
    
SELECT
    TABLE_NAME,
    TABLE_SCHEMA,
    DATE(LAST_ALTERED) AS LAST_ALTERED_DATE
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    LAST_ALTERED > DATEADD(DAY, -2, CURRENT_TIMESTAMP)
    AND TABLE_TYPE = 'BASE TABLE' -- BASE TABLE MEANS PERMANENT OR TRANSIENT
    AND TABLE_NAME IN (
        'ACI_SCORING_10K_BASE',
        'ACI_SCORING_ACC_EXPORT',
        'ACI_SCORING_SALESPLAY',
        'ACI_SCORING_SRCHTERMS',
        'ACI_O2_DIM'
    ) -- PASS A TABLE OR A LIST
ORDER BY
    LAST_ALTERED DESC;

    
    
-- All users using this table

SELECT
    B.TABLE_NAME AS TABLE_NAME,
    A.USER_NAME AS USER_NAME,
    COUNT(0)
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY(RESULT_LIMIT => 10000)
    ) A --TO GET QUERY HISTORY DATA
    INNER JOIN INFORMATION_SCHEMA.TABLES B ON CONTAINS(A.QUERY_TEXT, 'ACI_O2_DIM') -- LOOKUP FOR THE TABLE NAME INSIDE THE QUERY HISTORY TEXT
WHERE
    B.TABLE_NAME = 'ACI_O2_DIM' -- PASS OUR TABLE OR LIST OF TABLES USING IN (TABLE1, TABLE 2...)
    AND A.QUERY_ID IS NOT NULL -- WE JUST WANT QUERY_ID NOT NULLS -- IF NULLS IT MEANS IS A SCHEDULE TASK YET TO START
    AND A.END_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP()) -- WE WANT FOR 1 DAYS, WE CAN CHANGE IT
GROUP BY
    TABLE_NAME,
    USER_NAME;


  
-------------------------------------- TASK AUDIT QUERIES----------------------------------
-------------------------------------------------------------------------------------------
    
--List of all tasks in private and public
    
SHOW TASKS IN SCHEMA AKP_PRIVATE;-- RETRIEVE TASKS FROM PRIVATE
SHOW TASKS IN SCHEMA AKP_PUBLIC; -- RETRIEVE TASKS FROM PUBLIC
    
    
--TO UNION THESE RESULTS (IT WORKS ONLY IF YOU EXECUTE THE FOLLOWING QUERIES AFTER ABOVE QUERIES BECAUSE IT USES THE LAST QUERIES EXECUTED IN POSITIONAL-LAST EXECUTED BASIS)

SELECT
    *
FROM
    TABLE(RESULT_SCAN(LAST_QUERY_ID(-2)))

    UNION ALL

SELECT
    *
FROM
    TABLE(RESULT_SCAN(LAST_QUERY_ID())) 
    
    
--How often run/day

SELECT
    DATE(COMPLETED_TIME) AS RUN_DATE,
    NAME AS TASK_NAME,
    COUNT(0) TASK_RUNS,
    SUM(
        DATEDIFF(MINUTE, QUERY_START_TIME, COMPLETED_TIME)
    ) as TASK_DURATION_CUMULATIVE
FROM
    TABLE(
        INFORMATION_SCHEMA.TASK_HISTORY(RESULT_LIMIT => 10000)
    )
WHERE
    COMPLETED_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP())
GROUP BY
    RUN_DATE,
    TASK_NAME
ORDER BY
    TASK_RUNS DESC;

    
--How many credits used
    
--USING UNION ALL TO SELECT FROM ADP_PUBLISH AND ADP_CXA_WH

SELECT
    A.NAME AS TASK_NAME,
    B.WAREHOUSE_NAME,
    B.CREDITS_USED_CLOUD_SERVICES AS CREDITS_USED
FROM
    TABLE(
        INFORMATION_SCHEMA.TASK_HISTORY(RESULT_LIMIT => 10000)
    ) A
    INNER JOIN TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_CXA_WH',
            RESULT_LIMIT => 10000
        )
    ) B ON A.QUERY_ID = B.QUERY_ID
WHERE
    A.COMPLETED_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP())
    AND A.QUERY_ID IS NOT NULL --ORDER BY CREDITS_USED DESC
UNION ALL
SELECT
    A.NAME AS TASK_NAME,
    B.WAREHOUSE_NAME,
    B.CREDITS_USED_CLOUD_SERVICES AS CREDITS_USED
FROM
    TABLE(
        INFORMATION_SCHEMA.TASK_HISTORY(RESULT_LIMIT => 10000)
    ) A
    INNER JOIN TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_PUBLISH',
            RESULT_LIMIT => 10000
        )
    ) B ON A.QUERY_ID = B.QUERY_ID
WHERE
    A.COMPLETED_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP())
    AND A.QUERY_ID IS NOT NULL;
    --ORDER BY CREDITS_USED DESC;
    
    
--User who wrote  ** WE CAN ONLY RETRIEVE THE USER WHO EXECUTES THE TASK**

--1. Run SHOW TASKS TO GENERATE A QUERY ID

SHOW TASKS;

--2. CREATE A TEMP TABLE TO STORE THE RESULTS FROM SHOW TASKS USING RESULT_SCAN FUNCTION
    
CREATE TEMPORARY TABLE TASK_AUTHORS AS
SELECT
    *
FROM
    TABLE(RESULT_SCAN(LAST_QUERY_ID()));

    
--3. PERFORM THE JOIN TO RETRIEVE THE USER FROM QUERY HISTORY - IT SHOWS UP ONLY THE EXECUTING USER

SELECT
    A.USER_NAME AS USER_NAME,
    B.NAME AS TASK_NAME
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_CXA_WH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN TABLE (
        INFORMATION_SCHEMA.TASK_HISTORY(RESULT_LIMIT => 10000)
    ) B ON A.QUERY_ID = B.QUERY_ID
    INNER JOIN TASK_AUTHORS C ON B.NAME = C.NAME
WHERE
    B.ROOT_TASK_ID = C.ID
    AND B.COMPLETED_TIME >= DATEADD('DAY', -7, CURRENT_TIMESTAMP())
    AND A.END_TIME >= DATEADD('DAY', -7, CURRENT_TIMESTAMP())
GROUP BY
    USER_NAME,
    TASK_NAME

UNION ALL -- COMBINES ADP_CXA AND ADP_PUBLISH

SELECT
    A.USER_NAME AS USER_NAME,
    B.NAME AS TASK_NAME
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_PUBLISH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN TABLE (
        INFORMATION_SCHEMA.TASK_HISTORY(RESULT_LIMIT => 10000)
    ) B ON A.QUERY_ID = B.QUERY_ID
    INNER JOIN TASK_AUTHORS C ON B.NAME = C.NAME
WHERE
    B.ROOT_TASK_ID = C.ID
    AND B.COMPLETED_TIME >= DATEADD('DAY', -7, CURRENT_TIMESTAMP())
    AND A.END_TIME >= DATEADD('DAY', -7, CURRENT_TIMESTAMP())
GROUP BY
    USER_NAME,
    TASK_NAME;


   
SELECT A.NAME, A.ERROR_MESSAGE FROM TABLE (INFORMATION_SCHEMA.TASK_HISTORY(RESULT_LIMIT => 10000)) A
INNER JOIN TABLE(INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(WAREHOUSE_NAME => 'ADP_CXA_WH',RESULT_LIMIT => 10000)) B
ON A.QUERY_ID = B.QUERY_ID
WHERE A.ERROR_MESSAGE IS NOT NULL
AND A.QUERY_START_TIME >= DATEADD('DAY', -1, CURRENT_TIMESTAMP())
GROUP BY A.NAME, A.ERROR_MESSAGE

UNION ALL

SELECT A.NAME, A.ERROR_MESSAGE FROM TABLE (INFORMATION_SCHEMA.TASK_HISTORY(RESULT_LIMIT => 10000)) A
INNER JOIN TABLE(INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(WAREHOUSE_NAME => 'ADP_PUBLISH',RESULT_LIMIT => 10000)) B
ON A.QUERY_ID = B.QUERY_ID
WHERE A.ERROR_MESSAGE IS NOT NULL
AND A.QUERY_START_TIME >= DATEADD('DAY', -1, CURRENT_TIMESTAMP())
GROUP BY A.NAME, A.ERROR_MESSAGE
;
    
-------------------------------------- STORED PROCEDURES AUDIT QUERIES----------------------------------
--------------------------------------------------------------------------------------------------------

--List of all procedures in private and public
   
SHOW PROCEDURES IN SCHEMA AKP_PRIVATE;-- RETRIEVE TASKS FROM PRIVATE
SHOW PROCEDURES IN SCHEMA AKP_PUBLIC; -- RETRIEVE TASKS FROM PUBLIC
    
--TO UNION THESE RESULTS (IT WORKS ONLY IF YOU EXECUTE THE FOLLOWING QUERIES AFTER ABOVE QUERIES BECAUSE IT USES THE LAST QUERIES EXECUTED IN POSITIONAL-LAST EXECUTED BASIS)

SELECT
    *
FROM
    TABLE(RESULT_SCAN(LAST_QUERY_ID(-2)))
WHERE
    SCHEMA_NAME != '' -- FOR SOME REASON SOME SCHEMA NAME APPEAR AS BLANK

    UNION ALL

SELECT
    *
FROM
    TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE
    SCHEMA_NAME != '';

    
--How often run/day

SELECT
    C.PROCEDURE_NAME AS PROCEDURE_NAME,
    A.END_TIME AS PROCEDURE_COMPLETED_TIME
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_CXA_WH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN TABLE(
        INFORMATION_SCHEMA.TASK_HISTORY(RESULT_LIMIT => 10000)
    ) B ON A.QUERY_ID = B.QUERY_ID
    INNER JOIN INFORMATION_SCHEMA.PROCEDURES C ON CONTAINS(B.QUERY_TEXT, C.PROCEDURE_NAME)
WHERE
    A.END_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP())
ORDER BY
    PROCEDURE_NAME;

    
--How many credits used

SELECT
    B.PROCEDURE_NAME AS PROCEDURE_NAME,
    A.CREDITS_USED_CLOUD_SERVICES AS CREDITS_USED
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_CXA_WH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN INFORMATION_SCHEMA.PROCEDURES B ON CONTAINS(A.QUERY_TEXT, B.PROCEDURE_NAME)
WHERE
    A.END_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP()) --ORDER BY CREDITS_USED DESC
UNION ALL
SELECT
    B.PROCEDURE_NAME AS PROCEDURE_NAME,
    A.CREDITS_USED_CLOUD_SERVICES AS CREDITS_USED
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_PUBLISH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN INFORMATION_SCHEMA.PROCEDURES B ON CONTAINS(A.QUERY_TEXT, B.PROCEDURE_NAME)
WHERE
    A.END_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP()) 
    
    
    
--User who wrote -

SHOW PROCEDURES IN SCHEMA AKP_PRIVATE;-- RETRIEVE TASKS FROM PRIVATE
SHOW PROCEDURES IN SCHEMA AKP_PUBLIC;-- RETRIEVE TASKS FROM PUBLIC
    

--TO UNION THESE RESULTS (IT WORKS ONLY IF YOU EXECUTE THE FOLLOWING QUERIES AFTER ABOVE QUERIES BECAUSE IT USES THE LAST QUERIES EXECUTED IN POSITIONAL-LAST EXECUTED BASIS)

SELECT
    *
FROM
    TABLE(RESULT_SCAN(LAST_QUERY_ID(-2)))
WHERE
    SCHEMA_NAME != ''

   UNION ALL

SELECT
    *
FROM
    TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE
    SCHEMA_NAME != '';

    
--2. CREATE A TEMP TABLE TO STORE THE RESULTS FROM SHOW SP USING RESULT_SCAN FUNCTION

CREATE TEMPORARY TABLE SP_AUTHORS AS
SELECT
    *
FROM
    TABLE(RESULT_SCAN(LAST_QUERY_ID()));

    
--3. PERFORM THE JOIN TO RETRIEVE THE USER FROM QUERY HISTORY - IT SHOWS UP ONLY THE EXECUTING USER
SELECT
    A.USER_NAME AS USER_NAME,
    B.NAME AS PROCEDURE_NAME
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_CXA_WH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN SP_AUTHORS B ON CONTAINS(A.QUERY_TEXT, B.NAME)
WHERE
    A.END_TIME >= DATEADD('DAY', -7, CURRENT_TIMESTAMP())
GROUP BY
    USER_NAME,
    PROCEDURE_NAME
UNION ALL-- COMBINES ADP_CXA AND ADP_PUBLISH

SELECT
    A.USER_NAME AS USER_NAME,
    B.NAME AS PROCEDURE_NAME
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_PUBLISH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN SP_AUTHORS B ON CONTAINS(A.QUERY_TEXT, B.NAME)
WHERE
    A.END_TIME >= DATEADD('DAY', -7, CURRENT_TIMESTAMP())
GROUP BY
    USER_NAME,
    PROCEDURE_NAME;

    
--Use of union all to capture all warehouses--  table level usage
    
--USING UNION ALL TO SELECT FROM ALL WAREHOUSES  LIST {ADP_PUBLISH, ADP_CXA_WH, BSM_QUERY, BSD_PUBLISH, EDM_PUBLISH}

SELECT
    A.WAREHOUSE_NAME AS WAREHOUSE_NAME,
    B.TABLE_NAME AS TABLE_NAME,
    A.END_TIME AS COMPLETED_TIME,
    COUNT(DISTINCT A.QUERY_ID) AS TOTAL_RUNS
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_CXA_WH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN INFORMATION_SCHEMA.TABLES B ON CONTAINS(A.QUERY_TEXT, 'LRS_DATA_UNIT_VERSION_TEST') -- TABLE NAME IS IN QUERY HISTORY DATA
    AND A.SCHEMA_NAME = B.TABLE_SCHEMA -- SCHEMA NAME IS CONSISTENT IN QUERY HISTORY VS TABLE CATALOG
WHERE
    B.TABLE_NAME = 'LRS_DATA_UNIT_VERSION_TEST' -- PASS OUR TABLE
    AND A.END_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP()) --LAST DAY
    AND A.QUERY_ID IS NOT NULL -- NOT NULLS ONLY -- IF THEYRE NULL MEANS THEY'RE SCHEDULED TASKS
GROUP BY
    WAREHOUSE_NAME,
    TABLE_NAME,
    COMPLETED_TIME

    UNION ALL

SELECT
    A.WAREHOUSE_NAME AS WAREHOUSE_NAME,
    B.TABLE_NAME AS TABLE_NAME,
    A.END_TIME AS COMPLETED_TIME,
    COUNT(DISTINCT A.QUERY_ID) AS TOTAL_RUNS
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'ADP_PUBLISH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN INFORMATION_SCHEMA.TABLES B ON CONTAINS(A.QUERY_TEXT, 'LRS_DATA_UNIT_VERSION_TEST')
    AND A.SCHEMA_NAME = B.TABLE_SCHEMA -- LOOKUP THE TABLE NAME INSIDE THE TASK CODE
WHERE
    B.TABLE_NAME = 'LRS_DATA_UNIT_VERSION_TEST' -- PASS OUR TABLE
    AND A.END_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP())
    AND A.QUERY_ID IS NOT NULL
GROUP BY
    WAREHOUSE_NAME,
    TABLE_NAME,
    COMPLETED_TIME

UNION ALL

SELECT
    A.WAREHOUSE_NAME AS WAREHOUSE_NAME,
    B.TABLE_NAME AS TABLE_NAME,
    A.END_TIME AS COMPLETED_TIME,
    COUNT(DISTINCT A.QUERY_ID) AS TOTAL_RUNS
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'BSM_QUERY',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN INFORMATION_SCHEMA.TABLES B ON CONTAINS(A.QUERY_TEXT, 'LRS_DATA_UNIT_VERSION_TEST')
    AND A.SCHEMA_NAME = B.TABLE_SCHEMA -- LOOKUP THE TABLE NAME INSIDE THE TASK CODE
WHERE
    B.TABLE_NAME = 'LRS_DATA_UNIT_VERSION_TEST' -- PASS OUR TABLE
    AND A.END_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP())
    AND A.QUERY_ID IS NOT NULL
GROUP BY
    WAREHOUSE_NAME,
    TABLE_NAME,
    COMPLETED_TIME

UNION ALL

SELECT
    A.WAREHOUSE_NAME AS WAREHOUSE_NAME,
    B.TABLE_NAME AS TABLE_NAME,
    A.END_TIME AS COMPLETED_TIME,
    COUNT(DISTINCT A.QUERY_ID) AS TOTAL_RUNS
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'BSD_PUBLISH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN INFORMATION_SCHEMA.TABLES B ON CONTAINS(A.QUERY_TEXT, 'LRS_DATA_UNIT_VERSION_TEST')
    AND A.SCHEMA_NAME = B.TABLE_SCHEMA -- LOOKUP THE TABLE NAME INSIDE THE TASK CODE
WHERE
    B.TABLE_NAME = 'LRS_DATA_UNIT_VERSION_TEST' -- PASS OUR TABLE
    AND A.END_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP())
    AND A.QUERY_ID IS NOT NULL
GROUP BY
    WAREHOUSE_NAME,
    TABLE_NAME,
    COMPLETED_TIME

UNION ALL

SELECT
    A.WAREHOUSE_NAME AS WAREHOUSE_NAME,
    B.TABLE_NAME AS TABLE_NAME,
    A.END_TIME AS COMPLETED_TIME,
    COUNT(DISTINCT A.QUERY_ID) AS TOTAL_RUNS
FROM
    TABLE(
        INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
            WAREHOUSE_NAME => 'EDM_PUBLISH',
            RESULT_LIMIT => 10000
        )
    ) A
    INNER JOIN INFORMATION_SCHEMA.TABLES B ON CONTAINS(A.QUERY_TEXT, 'LRS_DATA_UNIT_VERSION_TEST')
    AND A.SCHEMA_NAME = B.TABLE_SCHEMA -- LOOKUP THE TABLE NAME INSIDE THE TASK CODE
WHERE
    B.TABLE_NAME = 'LRS_DATA_UNIT_VERSION_TEST' -- PASS OUR TABLE
    AND A.END_TIME >= DATEADD(DAY, -1, CURRENT_TIMESTAMP())
    AND A.QUERY_ID IS NOT NULL
GROUP BY
    WAREHOUSE_NAME,
    TABLE_NAME,
    COMPLETED_TIME;

    
--Query for State of all tasks (last day) -- we can add mor warehouses to the query


SELECT
    NAME AS TASK_NAME,
    STATE AS TASK_STATE,
    DATE(QUERY_START_TIME) AS START_DATE,
    COUNT(0) AS TASK_RUNS
    
    
FROM
    TABLE(
        INFORMATION_SCHEMA.TASK_HISTORY(RESULT_LIMIT => 10000))
        where start_date >= dateadd(DAY, -1, CURRENT_TIMESTAMP())
        GROUP BY
    TASK_NAME,
    TASK_STATE,
    START_DATE
        ORDER BY
    TASK_RUNS DESC
    ;


    
--Daily update of all stored procedures created and updated
    
USE WAREHOUSE ADP_CXA_WH;-- CHANGE WAREHOUSE TO VALIDATE WITH OTHER WAREHOUSE

SELECT
    PROCEDURE_NAME AS PROCEDURE_NAME,
    DATE(CREATED) AS PROCEDURE_CREATED_DATE,
    DATE(LAST_ALTERED) AS LAST_ALTERED,
    CASE
        WHEN DATEDIFF(
            DAY,
            DATE(LAST_ALTERED),
            DATE(CURRENT_TIMESTAMP())
        ) = 0 THEN 'Altered today'
        WHEN (
            DATEDIFF(
                DAY,
                DATE(LAST_ALTERED),
                DATE(CURRENT_TIMESTAMP())
            ) >= 1
        )
        AND (
            DATEDIFF(
                DAY,
                DATE(LAST_ALTERED),
                DATE(CURRENT_TIMESTAMP())
            ) <= 7
        ) THEN 'Last 7 days'
        WHEN (
            DATEDIFF(
                DAY,
                DATE(LAST_ALTERED),
                DATE(CURRENT_TIMESTAMP())
            ) > 7
        )
        AND (
            DATEDIFF(
                DAY,
                DATE(LAST_ALTERED),
                DATE(CURRENT_TIMESTAMP())
            ) <= 30
        ) THEN 'Within last 30 days'
        WHEN (
            DATEDIFF(
                DAY,
                DATE(LAST_ALTERED),
                DATE(CURRENT_TIMESTAMP())
            ) > 30
        )
        AND (
            DATEDIFF(
                DAY,
                DATE(LAST_ALTERED),
                DATE(CURRENT_TIMESTAMP())
            ) <= 90
        ) THEN '1-3 Months'
        WHEN (
            DATEDIFF(
                DAY,
                DATE(LAST_ALTERED),
                DATE(CURRENT_TIMESTAMP())
            ) > 90
        )
        AND (
            DATEDIFF(
                DAY,
                DATE(LAST_ALTERED),
                DATE(CURRENT_TIMESTAMP())
            ) <= 180
        ) THEN '3-6 Months'
          ELSE '>6 Months'
    END AS LAST_ALTERED_DATE_TIERS
FROM
    INFORMATION_SCHEMA.PROCEDURES
GROUP BY
    PROCEDURE_NAME,
    PROCEDURE_CREATED_DATE,
    LAST_ALTERED
ORDER BY
    LAST_ALTERED ASC;



 
