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

Services that coordinate activities across Snowflake





