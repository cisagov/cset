PRINT(N'Setting existing user in USERS table IsLocalAccount column as true in the db')
UPDATE USERS SET IsLocalAccount = 1 WHERE PrimaryEmail NOT LIKE '%@%';