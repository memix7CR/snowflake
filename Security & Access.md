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

### System Defined Roles

:upper_right: **ORGADMIN**
- Role that manages operations at the organization level:
  - Can create accounts in the organization
  - View all accounts in the organization 
  - View usage across the organization

:upper_right: **ACCOUNTADMIN**
- Encapsulates SECURITYADMIN and SYSADMIN

:upper_right: **USERADMIN**
- Role that is dedicated to user and role management only

:upper_right: **SECURITYADMIN**
- Creates, modify, drops user, roles, monitor, grants

:upper_right: **SYSYADMIN**
- Creates Virtual Warehouses, Databases and its objects
- Recommend to assign **CUSTOM ROLES** to **SYSADMIN** 

:upper_right: **PUBLIC**
- Automatically granted to all users
- Can own secured objects
- Used where explicit access control is not required

:upper_right: **CUSTOM ROLES**
- Created by **SECURITYADMIN**
- Assign to **SYSADMIN**
- Create custom roles with least privilege and role them up


![](/assets/roles.png)


#### Privilege Inheritance

![](/assets/role_2.png)

