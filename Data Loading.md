
### File Location

- On Local
- On Cloud
      - AWS : can load directly from S3 to SF
      - AWS : can load directly from Blob Storage to SF
      - AWS : can load directly from GCS to SF

### File Type

- Structured
     - Delimited files ( CSV, TSV, etc.)
- Semi-structured
     - JSON
     - ORC
     - Parquet
     - XML
**Note:** If files are uncompressed, SF gzip them on load (can disable)

### Loading Data options

- Specifying specific list of files to upload **(max 1000 files in list at a time)**
- Identify files via pattern matching (regex)
- Validating data on load:
    - Use VALIDATION_MODE (validate errors on load, does not load into table)
    - ON_ERROR to run actions to follow
- When COPY command runs, Snowflake sets load status 
- Metadata (expires after 64 days)
    - Name of file
    - File size
    - Etag of file
    - #rows parsed
    - Timestamp on last load
    - Info on errors during load
- SF recommends removing the data from stage once the load is completed to avoid reloading again
    - Use **REMOVE (and specify PURGE IN COPY argument)**
- For semi-structured:
    - Snowflake loads semi-structured data to **VARIANT** type column
    - Can load semi-structured data into multiple columns but it must be stored as field in structured data
    - Use **FLATTEN** to explode values into multiple **rows**
    - Data Transformations during load : reordering, column-omission, casts, truncate text


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

- Data objects, flexibility for data loading. Option when planning regular data loads that involve **multiple users** and **multiple tables**


:arrow_right: Table Stage (@%)

- Convenient for files acceses by **multiple users** but copying into a **single table**
- Cannot be altered or dropped, file format not supported.

[Bluk Loading from AWS](https://docs.snowflake.com/en/user-guide/data-load-s3.html)\
[Bluk Loading from Azure](https://docs.snowflake.com/en/user-guide/data-load-azure.html)\
[Bluk Loading from GCP](https://docs.snowflake.com/en/user-guide/data-load-gcs.html)


### Continuous Loading

#### Snowpipe

Enable data loading from files as soon they land the stages (incremental load), instead of manually executing COPY on a schedule.
Recommended for micro-batching (smaller)

- Using PIPE which is a first-class Snowflake object that contains a COPY statement used by Snowpipe
- Mechanisms for detecting the staged files:
   - Snowpipe using cloud messaging
   - Calling Snowpipe REST API

- Snowpipe normally loads older files first but it doesn not guarantee that files are loaded in the same order as staged
- It uses **file loading metadata** associated with each pipe object to prevent reloading the same files
- Load History is stored in the metadata of the pipe for **14 days**


![](/assets/snowpipe.png)


### UNLOADING DATA

#### General

Allows to export data out of Snowflake
- Uses **COPY INTO** <location> (external or internal stage)
- Use **GET** command to download the file
- Use **SELECT** and other SQL syntax to build the data for export
- To download into a single file use property **SINGLE=TRUE** or FALSE for multiple files
      
#### Format and restrictions

##### Allowed formats for export (only UTF-8 encoding)
   -Delimited Files (CSV, TSV, etc.)
   -JSON
   -Parquet
      
##### Allowed compression for export
   -gzip (default)
   -bzip2
   -brotli
   -zstandard
      
##### Encryption for export
      
      
   
