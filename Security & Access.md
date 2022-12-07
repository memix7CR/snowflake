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

:arrow_right: **ORGADMIN**
- Role that manages operations at the organization level:
  - Can create accounts in the organization
  - View all accounts in the organization 
  - View usage across the organization

:arrow_right: **ACCOUNTADMIN**
- Encapsulates SECURITYADMIN and SYSADMIN

:arrow_right: **USERADMIN**
- Role that is dedicated to user and role management only

:arrow_right: **SECURITYADMIN**
- Creates, modify, drops user, roles, monitor, grants

:arrow_right: **SYSYADMIN**
- Creates Virtual Warehouses, Databases and its objects
- Recommend to assign **CUSTOM ROLES** to **SYSADMIN** 

:arrow_right: **PUBLIC**
- Automatically granted to all users
- Can own secured objects
- Used where explicit access control is not required

:arrow_right: **CUSTOM ROLES**
- Created by **SECURITYADMIN**
- Assign to **SYSADMIN**
- Create custom roles with least privilege and role them up


![](/assets/roles.png)


#### Privilege Inheritance

![](/assets/role_2.png)

### Data Security

#### End-to-End Encryption

Snowflake encrypts all data at rest and in-transit **no additional cost**

#### Client Side Encryption (Internal Stage)

- If the stage is an internal stage data files are automatically encrypted by the Snowflake client on the user’s local machine prior to being transmitted to the internal stage.

#### Client Side Encryption (External stage)

- Client-side encryption means that a client encrypts data before copying it into a cloud storage staging area.

    - The customer creates a secret master key, which is shared with Snowflake.

    - The client, which is provided by the cloud storage service, generates a random encryption key and encrypts the file before uploading it into cloud storage. The random encryption key, in turn, is encrypted with the customer’s master key.

    - Both the encrypted file and the encrypted random key are uploaded to the cloud storage service. The encrypted random key is stored with the file’s metadata.


![](/assets/security.png)


### Key Rotation

- Snowflake encrypts all data by default and keys are rotated
- Hierarchical Key Model for the Key Management:
  - Root Key
  - Account Master Key (auto-rotate if >30 days old)
  - Table Master Key (auto-rotate if >30 days old)
  - File Keys

![](/assets/rekeying.png)

