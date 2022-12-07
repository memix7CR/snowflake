# Cloud Data Platform and Arquitecture

## Service

- OLAP SaaS
- Native SQL based on public cloud (not on-prem options)
- Decoupled storage - computation


## Storage

- Data objects not directly visible (except via SQL)
- Storage managed by Snowflake


## Query Processing

- Virtual Warehouse to process queries
- Each VW is am independent MPP (Massive Parallel Processing) compute cluster

## Arquitecture 

- Hybrid of traditional **shared-disk** and **shared-nothing**

![](/assets/snow_arqui.png)

## Cloud Services

Services that coordinate and ties activities across Snowflake

- Authentication
- Infrastructure Management
- Metadata Management
- Query Parsing & Optimization
- Access Control

### Caches

SF caches different data to improve query performance and reducing costs

#### Metadata cache

:arrow_right:   Cloud Services Layer\
:arrow_right:   Improve compile time for queries against commonly used tables\

#### Result cache

:arrow_right:   Cloud Services Layer\
:arrow_right: Holds the query results\
:arrow_right: If customer runs exact same query within 24 hrs, result cache is used (no warehouse is required)\

#### Local Disk/Warehouse/SSD Cache
:arrow_right:   Storage Layer\
:arrow_right: Caches the data used by SQL query in its local SSD and memory\
:arrow_right: Improves query performance if same data was used (less time to fetch remotely)\
:arrow_right: Cache dropped when the warehouse is suspended\



