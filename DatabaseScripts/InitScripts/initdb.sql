-- Initialize CSET Database
-- This script creates the database and provides instructions for running all SQL files

PRINT 'Starting CSET Database Initialization...'
GO

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name
FROM sys.databases
WHERE name = 'CSETWeb')
BEGIN
    CREATE DATABASE CSETWeb
    PRINT 'Created CSETWeb database'
END
ELSE
BEGIN
    PRINT 'Database CSETWeb already exists'
END
GO

USE CSETWeb
GO

-- Generate the schema and data
PRINT 'Running GenerateCSETWebSchema.sql...'
:r /var/opt/mssql/scripts/InitScripts/GenerateCSETWebSchema.sql
PRINT 'Running GenerateCSETWebData.sql...'
:r /var/opt/mssql/scripts/InitScripts/GenerateCSETWebData1.sql
:r /var/opt/mssql/scripts/InitScripts/GenerateCSETWebData2.sql
