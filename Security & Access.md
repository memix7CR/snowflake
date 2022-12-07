### Features

Below features are supported to Business Critical or Enterprise

| Enterprise Edition                     | Business Critical                                              | 
| :---                                   |      :----                                                     |      
| Configure session policies             | Private communication between the VPC and Snowflake            | 
| Periodic Rekeying of encrypted data    | Private communication to internat stages                       | 
|                                        | Support for encrypting data using customer managed keys (BYOK) | 
|                                        | HIPAA, PCI DSS, HITRUST CSF, FedRAMP,IRAP compliance           | 



### Authentication

#### Federated authentication 
Enable users to connect to Snowflake using secure SSO (single sign-on)


| Native Supported  | Other SAML 2.0-complaint vendors |
| :---              |  :---                            |
| Okta              | Google G Suite                   |
| Microsoft ADFS    | Microsoft Azure Active Directory |
|                   | One Login                        |
|                   | Ping One                         |



### MFA 

- At a minimum, **ACCOUNTADMIN** role should be assigned to use MFA
- Powered by **Duo System**. Customers need to enable it
- Used with Snow Web UI, SnowSQL, ODBC, JDBC, Python Connector  

### Network Policy

- Allow access based on IP whilelist or restrictions to IP blacklist
  - Apply via SQL or WebUI
  - Only **SECURITYADMIN OR ACCOUNTADMIN** can modify, drop or create
  - Created at user and account level

### Access Control Models

:arrow_right: **DAC** Discretionary Access Control 
- All object have an owner, owner can grant access to their objects

:arrow_right: **RBAC** Role-Based Access Control
- Privileged are assigned to roles, then roles to users

