### Micro-Partitions

- Snowflake tables are divided in micro-partitions
- Micropartitions are compressed-columnar data:
  - Max size of **16MB** (compressed), **50-500MB** (uncompressed)
  - Data is available by SQL not directly
  - Immutable once created
- Data ingestion order dictates partition of the data
- Natural clustering is used by Snowflake to colocate the data with same value or range
  - It helps to avoid overlapping of micro-partitions and less clustering depth
  - Improve query performance avoiding scanning unnecesary micro-partitions

![](/assets/depth.png)


- **Clustering Key**
  - Recommended once your table grows really large (multi-terabyte range)
  - Clustering Keys are subset of columns designed to colocate the data in the same micro-partitions

### Zero-Copy Cloning

-Enable cloning tables
- Snowflake references the original data (micro-partition) with no storage cost
  - When a change is made to the cloned table (update, insert, delete) then a new micro-partition is created (incurs storage costs)
- Cloned object does not inherit source granted privileges.


### Types of Tables

#### Temporary

- Use to store data temporarily
- Exists within the session (data purged after session ends)
- Not visibke to other users, not recoverable
- Default **1 day of time travel**

#### Transient

- Persist until **dropped**
- Same functions as permament table except not **Fail-Safe** mode
- Default **1 day of time-travel**


#### Permanent

- **7 days of File-Safe**
- Default **1 day of Time Travel** up to 90 days >= Enterprise Edition

#### External
