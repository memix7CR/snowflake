
--CHECK ALL THE TASKS FROM TASK_HISTORY VIEW THAT STARTS WITH %CALL IN THE QUERY TEXT AND WHERE RUN TIME IS > 5 MIN – THIS IS TO CHECK STORE PROCEDURES
 
select
    query_id,
    query_text,
    query_start_time,
    completed_time,
    return_value,
    state,
    error_code,
    error_message,
    datediff(minute, query_start_time, completed_time) as run_time_in_min
      from table(information_schema.task_history(result_limit => 1000))
                 where datediff(minute, query_start_time, completed_time) > 5
                 and query_start_time > dateadd(day, -1, current_timestamp())
                 and query_text like 'CALL%' -- IT WILL BRING ALL THE TASKS THAT CALL AN STORE PROCEDURE
                 order by run_time_in_min desc;
                 
                 
                 
   --CHECK ALL THE TASK FROM TASK_HISTORY VIEW THAT MATCH AN SPECIFIC CALL FUNCTION IN THE QUERY TEXT AND WHERE RUN TIME IS > 5 MIN
select
    query_id,
    query_text,
    query_start_time,
    completed_time,
    return_value,
    state,
    error_code,
    error_message,
    datediff(minute, query_start_time, completed_time) as run_time_in_min
      from table(information_schema.task_history(result_limit => 1000))
                 where datediff(minute, query_start_time, completed_time) > 5
                 and query_start_time > dateadd(day, -1, current_timestamp())
                 and query_text like 'CALL ACI_10A_SALES_PLAYS_SP()'  -- PROVIDE THE STORE PROCEDURE CALL FUNCTION
                 order by run_time_in_min desc;
                 
                 
                 
                 
--SHOW PROPERTIES AND VALUES FROM YOUR PROCEDURE – THIS HELPS US CHECK THE VALUES AND SQL CODE FROM OUR STORE PROCEDURE
DESCRIBE PROCEDURE ACI_10A_SALES_PLAYS_SP();



-- SHOW ALL THE PROCEDURES AND THEIR DETAILS FOLLOWING A PATTERN NAME – THIS ALLOW US FOR BULK QUERY FROM A GIVEN PATTERN
SHOW PROCEDURES LIKE 'ACI_10%';


--CHECK THE LAST ALTERED DATE FROM MY LIST OF TABLES. – THIS ALLOWS US TO CHECK THE LAST ALTERED DATE FOR ANY TABLE, WE CAN INCREASE THE FILTER TO MULTIPLE DAYS BACK IF NEEDED IN THE WHERE CLAUSES -1, -2, -3……
 
select
table_schema,
table_name,
last_altered as modify_time
from information_schema.tables
where last_altered > DATEADD(DAY, -1, CURRENT_TIMESTAMP)
and table_type = 'BASE TABLE'
and table_name IN ('ACI_SCORING_10K_BASE', 'ACI_SCORING_ACC_EXPORT', 'ACI_SCORING_SALESPLAY','ACI_SCORING_SRCHTERMS')
order by last_altered desc;


-- check long running queries

select
    query_id,
    query_text,
    user_name,
    warehouse_name,
    warehouse_size,
    role_name,
    start_time,
    end_time,
    to_decimal(compilation_time/60000, 10, 1) as compilation_time_in_min,
    to_decimal(execution_time/60000, 10, 1)  as execution_time_in_min,
    execution_status,
    credits_used_cloud_services,
    datediff(minute, start_time, end_time) as run_time_in_min
      from table(information_schema.query_history_by_warehouse( warehouse_name=>'ADP_CXA_WH',result_limit => 1000))
                 where datediff(minute, start_time, end_time) > 10
                 and start_time > dateadd(day, -1, current_timestamp())
                 order by run_time_in_min desc;
                 
 
