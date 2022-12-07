### Bulk Loading from Local File System

1- Upload one or more data files to a Snowflake stage using **PUT** command from your local machine 
(not executable from web UI).  Snowflake encrypts the data in the client and move the data to the stage.

2- Use the **COPY INTO** command to load the contents from stage to table

![](/assets/bulk_load.png)

### Types of Internal Stages

Each **user** and **table** is allocated automatically an internal stage.  We can add also **internal named** stages

:arrow_right:  User Stage (@~)

- Option for files accesed by a **single user** but copying into a multiple tables
- Cannot be altered or dropped, file format not supported.

:arrow_right:  Named Stage (@)

- Data objects, flexibility for data loading. Option when planning regular data loads that involve multiple users and multiple tables


:arrow_right: Table Stage (@%)

- Convenient for files acceses by **multiple users** but copying into a **single table**
- Cannot be altered or dropped, file format not supported.
