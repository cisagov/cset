CREATE PROCEDURE [dbo].[spEXECsp_RECOMPILE] AS 

SET NOCOUNT ON 

-- 1 - Declaration statements for all variables
DECLARE @TableName varchar(128)
DECLARE @OwnerName varchar(128)
DECLARE @CMD1 varchar(8000)
DECLARE @TableListLoop int
DECLARE @TableListTable table
(UIDTableList int IDENTITY (1,1),
OwnerName varchar(128),
TableName varchar(128))

-- 2 - Outer loop for populating the database names
INSERT INTO @TableListTable(OwnerName, TableName)
SELECT u.[Name], o.[Name]
FROM sys.objects o
INNER JOIN sys.schemas u
 ON o.schema_id  = u.schema_id
WHERE o.Type = 'V'
ORDER BY o.[Name]



-- 3 - Determine the highest UIDDatabaseList to loop through the records
SELECT @TableListLoop = MAX(UIDTableList) FROM @TableListTable

-- 4 - While condition for looping through the database records
WHILE @TableListLoop > 0
 BEGIN

 -- 5 - Set the @DatabaseName parameter
 SELECT @TableName = TableName,
 @OwnerName = OwnerName
 FROM @TableListTable
 WHERE UIDTableList = @TableListLoop

 -- 6 - String together the final backup command
 SELECT @CMD1 = 'EXEC sp_recompile ' + '[' + @OwnerName + '.' + @TableName + ']' + char(13)

 -- 7 - Execute the final string to complete the backups
 SELECT @CMD1
 --EXEC (@CMD1)
 end
