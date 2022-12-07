### Bulk Loading from Local File System

1- Upload one or more data files to a Snowflake stage using **PUT** command from your local machine 
(not executable from web UI).  Snowflake encrypts the data in the client and move the data to the stage.

2- Use the **COPY INTO** command to load the contents from stage to table

![](/assets/bulk_load.png)

### Types of Internal Stages

- 
