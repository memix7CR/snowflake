### Micro-Partitions

- Snowflake tables are divided in micro-partitions
- Micropartitions are compressed-columnar data:
  - Max size of **16MB** (compressed), **50-500MB** (uncompressed)
  - Data is accesible by SQL not directly
  - Immutable once created
- Data ingestion order dictates partition of the data
- Natural clustering is used by Snowflake to colocate the data with same value or range
  - It helps to avoid overlapping of micro-partitions and less clustering depth
  - Improve query performance avoiding scanning unnecesary micro-partitions

![](/assets/depth.png)
