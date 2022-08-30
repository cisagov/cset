-- Drops all Windows user accounts from the current database
-- that belong to the INEL-NT domain.

DECLARE @getname CURSOR
DECLARE @name nvarchar(100)
DECLARE @query nvarchar(200)
SET @getname = CURSOR FOR
SELECT name 
from sys.database_principals
where type = 'U'
      and sid is not null
      and name like 'INEL-NT\%'

OPEN @getname
FETCH NEXT
FROM @getname INTO @name
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @query = 'DROP USER [' +  @name + ']';
	print @query;
	EXEC (@query);
	
    FETCH NEXT
    FROM @getname INTO @name
END

CLOSE @getname
DEALLOCATE @getname

