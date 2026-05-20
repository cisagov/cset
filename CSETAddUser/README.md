# CSETAddUser
`CSETAddUser` is a utility for adding user accounts directly to a CSET instance 
without requiring an SMTP server. Ideal for self-hosted environments where 
email delivery isn't configured — rather than the typical signup flow (which sends a temporary 
password via email), administrators can create accounts directly from the command line
or a simple Windows interface.

> ⚠️ **Warning:** This tool is intended for administrators only. It should not be 
> accessible to end users, as it allows account creation without email verification 
> or any other identity checks.

To use the application, modify the `CSET_DB` connection string in `appsettings.json` 
to point to your SQL Server instance, adding `User ID` and `Password` credentials as needed.

Example:
```json
"CSET_DB": "Server=myserver;Database=CSETWeb;User ID=myuser;Password=mypassword;"
```
