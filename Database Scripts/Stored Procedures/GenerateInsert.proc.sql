
CREATE PROCEDURE dbo.GenerateInsert
(
  @ObjectName nvarchar(261)
, @TargetObjectName nvarchar(261) = NULL
, @OmmitInsertColumnList bit = 0
, @GenerateSingleInsertPerRow bit = 0
, @UseSelectSyntax bit = 0
, @UseColumnAliasInSelect bit = 0
, @FormatCode bit = 1
, @GenerateOneColumnPerLine bit = 0
, @GenerateGo bit = 0
, @PrintGeneratedCode bit = 1
, @TopExpression nvarchar(max) = NULL
, @FunctionParameters nvarchar(max) = NULL
, @SearchCondition nvarchar(max) = NULL
, @OrderByExpression nvarchar(max) = NULL
, @OmmitUnsupportedDataTypes bit = 1
, @PopulateIdentityColumn bit = 0
, @PopulateTimestampColumn bit = 0
, @PopulateComputedColumn bit = 0
, @GenerateProjectInfo bit = 1
, @GenerateSetNoCount bit = 1
, @GenerateStatementTerminator bit = 1
, @ShowWarnings bit = 1
, @Debug bit = 0
)
AS
/*******************************************************************************
Procedure: GenerateInsert (Build 6)
Decription: Generates INSERT statement(s) for data in a table.
Purpose: To regenerate data at another location.
  To script data populated in automated way.
  To script setup data populated in automated/manual way.
Project page: http://github.com/drumsta/sql-generate-insert
Arguments:
  @ObjectName nvarchar(261)
    Format: [schema_name.]object_name
    Specifies the name of a table or view to generate the INSERT statement(s) for
  @TargetObjectName nvarchar(261) = NULL
    Specifies the name of target table or view to insert into
  @OmmitInsertColumnList bit = 0
    When 0 then syntax is like INSERT INTO object (column_list)...
    When 1 then syntax is like INSERT INTO object...
  @GenerateSingleInsertPerRow bit = 0
    When 0 then only one INSERT statement is generated for all rows
    When 1 then separate INSERT statement is generated for every row
  @UseSelectSyntax bit = 0
    When 0 then syntax is like INSERT INTO object (column_list) VALUES(...)
    When 1 then syntax is like INSERT INTO object (column_list) SELECT...
  @UseColumnAliasInSelect bit = 0
    Has effect only when @UseSelectSyntax = 1
    When 0 then syntax is like SELECT 'value1','value2'
    When 1 then syntax is like SELECT 'value1' column1,'value2' column2
  @FormatCode bit = 1
    When 0 then no Line Feeds are generated
    When 1 then additional Line Feeds are generated for better readibility
  @GenerateOneColumnPerLine bit = 0
    When 0 then syntax is like SELECT 'value1','value2'...
      or VALUES('value1','value2')...
    When 1 then syntax is like
         SELECT
         'value1'
         ,'value2'
         ...
      or VALUES(
         'value1'
         ,'value2'
         )...
  @GenerateGo bit = 0
    When 0 then no GO commands are generated
    When 1 then GO commands are generated after each INSERT
  @PrintGeneratedCode bit = 1
    When 0 then generated code will be printed using PRINT command
    When 1 then generated code will be selected using SELECT statement 
  @TopExpression nvarchar(max) = NULL
    When supplied then INSERT statements are generated only for TOP rows
    Format: (expression) [PERCENT]
    Example: @TopExpression='(5)' is equivalent to SELECT TOP (5)
    Example: @TopExpression='(50) PERCENT' is equivalent to SELECT TOP (5) PERCENT
  @FunctionParameters nvarchar(max) = NULL
    When @ObjectName is type of Table-Valued User-Defined function or Inline User-Defined function
      then @FunctionParameters should be supplied to pass to function.
    One or more parameters can be specified.
    Example: @FunctionParameters='(1)' is equivalent to SELECT * FROMN ObjectName(1)
  @SearchCondition nvarchar(max) = NULL
    When supplied then specifies the search condition for the rows returned by the query
    Format: <search_condition>
    Example: @SearchCondition='column1 != ''test''' is equivalent to WHERE column1 != 'test'
  @OrderByExpression nvarchar(max) = NULL
    When supplied then sorts data returned by a query. The parameter doesn't apply to the ranking function like ROW_NUMBER, RANK, DENSE_RANK, and NTILE.
    Format: <order_by_expression>
    Example: @OrderByExpression='DATEPART(year, HireDate) DESC, LastName DESC COLLATE Latin1_General_CS_AS'
  @OmmitUnsupportedDataTypes bit = 1
    When 0 then error is raised on unsupported data types
    When 1 then columns with unsupported data types are excluded from generation process
  @PopulateIdentityColumn bit = 1
    When 0 then identity columns are excluded from generation process
    When 1 then identity column values are preserved on insertion
  @PopulateTimestampColumn bit = 0
    When 0 then rowversion/timestamp column is inserted using DEFAULT value
    When 1 then rowversion/timestamp column values are preserved on insertion,
      useful when restoring into archive table as varbinary(8) to preserve history
  @PopulateComputedColumn bit = 0
    When 0 then computed columns are excluded from generation process
    When 1 then computed column values are preserved on insertion,
      useful when restoring into archive table as scalar values to preserve history
  @GenerateProjectInfo bit = 1
    When 0 then no spam is generated at all.
    When 1 then short comments are generated, i.e. SP build number and project page.
  @GenerateSetNoCount bit = 1
    When 0 then no SET NOCOUNT ON is generated at the beginning.
    When 1 then SET NOCOUNT ON is generated at the beginning.
  @GenerateStatementTerminator bit = 1
    When 0 then each statement is not separated by semicolon (;).
    When 1 then semicolon (;) is generated at the end of each statement.
  @ShowWarnings bit = 1
    When 0 then no warnings are printed.
    When 1 then warnings are printed if columns with unsupported data types
      have been excluded from generation process
    Has effect only when @OmmitUnsupportedDataTypes = 1
  @Debug bit = 0
    When 0 then no debug information are printed.
    When 1 then constructed SQL statements are printed for later examination
*******************************************************************************/
BEGIN
SET NOCOUNT ON;

DECLARE @CrLf char(2)
SET @CrLf = CHAR(13) + CHAR(10);
DECLARE @ColumnName sysname;
DECLARE @DataType sysname;
DECLARE @ColumnList nvarchar(max);
SET @ColumnList = N'';
DECLARE @SelectList nvarchar(max);
SET @SelectList = N'';
DECLARE @SelectStatement nvarchar(max);
SET @SelectStatement = N'';
DECLARE @OmittedColumnList nvarchar(max);
SET @OmittedColumnList = N'';
DECLARE @InsertSql nvarchar(max);
SET @InsertSql = N'INSERT INTO ' + COALESCE(@TargetObjectName,@ObjectName);
DECLARE @ValuesSql nvarchar(max);
SET @ValuesSql = N'VALUES (';
DECLARE @SelectSql nvarchar(max);
SET @SelectSql = N'SELECT ';
DECLARE @TableData table (TableRow nvarchar(max));
DECLARE @Results table (TableRow nvarchar(max));
DECLARE @TableRow nvarchar(max);
DECLARE @RowNo int;

IF PARSENAME(@ObjectName,3) IS NOT NULL
  OR PARSENAME(@ObjectName,4) IS NOT NULL
BEGIN
  RAISERROR(N'Server and database names are not allowed to specify in @ObjectName parameter. Required format is [schema_name.]object_name',16,1);
  RETURN -1;
END

IF OBJECT_ID(@ObjectName,N'U') IS NULL -- USER_TABLE
  AND OBJECT_ID(@ObjectName,N'V') IS NULL -- VIEW
  AND OBJECT_ID(@ObjectName,N'IF') IS NULL -- SQL_INLINE_TABLE_VALUED_FUNCTION
  AND OBJECT_ID(@ObjectName,N'TF') IS NULL -- SQL_TABLE_VALUED_FUNCTION
BEGIN
  RAISERROR(N'User table, view, table-valued or inline function %s not found or insuficient permission to query the provided object.',16,1,@ObjectName);
  RETURN -1;
END

IF NOT EXISTS (
  SELECT 1
  FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_TYPE IN ('BASE TABLE','VIEW')
    AND TABLE_NAME = PARSENAME(@ObjectName,1)
    AND (TABLE_SCHEMA = PARSENAME(@ObjectName,2)
      OR PARSENAME(@ObjectName,2) IS NULL)
) AND NOT EXISTS (
  SELECT *
  FROM INFORMATION_SCHEMA.ROUTINES
  WHERE ROUTINE_TYPE IN ('FUNCTION')
    AND DATA_TYPE = 'TABLE'
    AND SPECIFIC_NAME = PARSENAME(@ObjectName,1)
    AND (SPECIFIC_SCHEMA = PARSENAME(@ObjectName,2)
      OR PARSENAME(@ObjectName,2) IS NULL)
)
BEGIN
  RAISERROR(N'User table, view, table-valued or inline function %s not found or insuficient permission to query the provided object.',16,1,@ObjectName);
  RETURN -1;
END

DECLARE ColumnCursor CURSOR LOCAL FAST_FORWARD FOR
SELECT c.name ColumnName
,COALESCE(TYPE_NAME(c.system_type_id),t.name) DataType
FROM sys.objects o
  INNER JOIN sys.columns c ON c.object_id = o.object_id
  LEFT JOIN sys.types t ON t.system_type_id = c.system_type_id
    AND t.user_type_id = c.user_type_id
WHERE o.type IN (N'U',N'V',N'IF',N'TF')
  -- U = USER_TABLE
  -- V = VIEW
  -- IF = SQL_INLINE_TABLE_VALUED_FUNCTION
  -- TF = SQL_TABLE_VALUED_FUNCTION
  AND (o.object_id = OBJECT_ID(@ObjectName)
    OR o.name = @ObjectName)
  AND (COLUMNPROPERTY(c.object_id,c.name,'IsIdentity') != 1
    OR @PopulateIdentityColumn = 1)
  AND (COLUMNPROPERTY(c.object_id,c.name,'IsComputed') != 1
    OR @PopulateComputedColumn = 1)
ORDER BY COLUMNPROPERTY(c.object_id,c.name,'ordinal') -- ORDINAL_POSITION
FOR READ ONLY
;
OPEN ColumnCursor;
FETCH NEXT FROM ColumnCursor INTO @ColumnName,@DataType;

WHILE @@FETCH_STATUS = 0
BEGIN
  -- Handle different data types
  DECLARE @ColumnExpression nvarchar(max);
  SET @ColumnExpression = 
    CASE
    WHEN @DataType IN ('char','varchar','text','uniqueidentifier')
    THEN N'ISNULL(''''''''+REPLACE(CONVERT(varchar(max),'+  QUOTENAME(@ColumnName) + N'),'''''''','''''''''''')+'''''''',''NULL'') COLLATE database_default'
      
    WHEN @DataType IN ('nchar','nvarchar','sysname','ntext','sql_variant','xml')
    THEN N'ISNULL(''N''''''+REPLACE(CONVERT(nvarchar(max),'+  QUOTENAME(@ColumnName) + N'),'''''''','''''''''''')+'''''''',''NULL'') COLLATE database_default'
      
    WHEN @DataType IN ('int','bigint','smallint','tinyint','decimal','numeric','bit')
    THEN N'ISNULL(CONVERT(varchar(max),'+  QUOTENAME(@ColumnName) + N'),''NULL'') COLLATE database_default'
      
    WHEN @DataType IN ('float','real','money','smallmoney')
    THEN N'ISNULL(CONVERT(varchar(max),'+  QUOTENAME(@ColumnName) + N',2),''NULL'') COLLATE database_default'
      
    WHEN @DataType IN ('datetime','smalldatetime','date','time','datetime2','datetimeoffset')
    THEN N'''CONVERT('+@DataType+',''+ISNULL(''''''''+CONVERT(varchar(max),'+  QUOTENAME(@ColumnName) + N',121)+'''''''',''NULL'') COLLATE database_default' + '+'',121)'''

    WHEN @DataType IN ('rowversion','timestamp')
    THEN
      CASE WHEN @PopulateTimestampColumn = 1
      THEN N'''CONVERT(varbinary(max),''+ISNULL(''''''''+CONVERT(varchar(max),CONVERT(varbinary(max),'+  QUOTENAME(@ColumnName) + N'),1)+'''''''',''NULL'') COLLATE database_default' + '+'',1)'''
      ELSE N'''NULL''' END

    WHEN @DataType IN ('binary','varbinary','image')
    THEN N'''CONVERT(varbinary(max),''+ISNULL(''''''''+CONVERT(varchar(max),CONVERT(varbinary(max),'+  QUOTENAME(@ColumnName) + N'),1)+'''''''',''NULL'') COLLATE database_default' + '+'',1)'''

    WHEN @DataType IN ('geography')
    -- convert geography to text: ?? column.STAsText();
    -- convert text to geography: ?? geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656 )', 4326);
    THEN NULL

    ELSE NULL END;

  IF @ColumnExpression IS NULL
    AND @OmmitUnsupportedDataTypes != 1
  BEGIN
    RAISERROR(N'Datatype %s is not supported. Use @OmmitUnsupportedDataTypes to exclude unsupported columns.',16,1,@DataType);
    RETURN -1;
  END

  IF @ColumnExpression IS NULL
  BEGIN
    SET @OmittedColumnList = @OmittedColumnList
      + CASE WHEN @OmittedColumnList != N'' THEN N'; ' ELSE N'' END
      + N'column ' + QUOTENAME(@ColumnName)
      + N', datatype ' + @DataType;
  END

  IF @ColumnExpression IS NOT NULL
  BEGIN
    SET @ColumnList = @ColumnList
      + CASE WHEN @ColumnList != N'' THEN N',' ELSE N'' END
      + QUOTENAME(@ColumnName)
      + CASE WHEN @GenerateOneColumnPerLine = 1 THEN @CrLf ELSE N'' END;
  
    SET @SelectList = @SelectList
      + CASE WHEN @SelectList != N'' THEN N'+'',''+' + @CrLf ELSE N'' END
      + @ColumnExpression
      + CASE WHEN @UseColumnAliasInSelect = 1 AND @UseSelectSyntax = 1 THEN N'+'' ' + QUOTENAME(@ColumnName) + N'''' ELSE N'' END
      + CASE WHEN @GenerateOneColumnPerLine = 1 THEN N'+CHAR(13)+CHAR(10)' ELSE N'' END;
  END

  FETCH NEXT FROM ColumnCursor INTO @ColumnName,@DataType;
END

CLOSE ColumnCursor;
DEALLOCATE ColumnCursor;

IF NULLIF(@ColumnList,N'') IS NULL
BEGIN
  RAISERROR(N'No columns to select.',16,1);
  RETURN -1;
END

IF @Debug = 1
BEGIN
  PRINT(N'--Column list');
  PRINT(@ColumnList);
END

IF NULLIF(@OmittedColumnList,'') IS NOT NULL
  AND @ShowWarnings = 1
BEGIN
  PRINT(N'--*************************');
  PRINT(N'--WARNING: The following columns have been omitted because of unsupported datatypes: ' + @OmittedColumnList);
  PRINT(N'--*************************');
END

IF @GenerateSingleInsertPerRow = 1
BEGIN
  SET @SelectList = 
    N'''' + @InsertSql + N'''+' + @CrLf
    + CASE WHEN @FormatCode = 1
      THEN N'CHAR(13)+CHAR(10)+' + @CrLf
      ELSE N''' ''+'
      END
    + CASE WHEN @OmmitInsertColumnList = 1
      THEN N''
      ELSE N'''(' + @ColumnList + N')''+' + @CrLf
      END
    + CASE WHEN @FormatCode = 1
      THEN N'CHAR(13)+CHAR(10)+' + @CrLf
      ELSE N''' ''+'
      END
    + CASE WHEN @UseSelectSyntax = 1
      THEN N'''' + @SelectSql + N'''+'
      ELSE N'''' + @ValuesSql + N'''+'
      END
    + @CrLf
    + @SelectList
    + CASE WHEN @UseSelectSyntax = 1
      THEN N''
      ELSE N'+' + @CrLf + N''')'''
      END
    + CASE WHEN @GenerateStatementTerminator = 1
      THEN N'+'';'''
      ELSE N''
      END
    + CASE WHEN @GenerateGo = 1
      THEN N'+' + @CrLf + N'CHAR(13)+CHAR(10)+' + @CrLf + N'''GO'''
      ELSE N''
      END
  ;
END ELSE BEGIN
  SET @SelectList =
    CASE WHEN @UseSelectSyntax = 1
      THEN N'''' + @SelectSql + N'''+'
      ELSE N'''(''+'
      END
    + @CrLf
    + @SelectList
    + CASE WHEN @UseSelectSyntax = 1
      THEN N''
      ELSE N'+' + @CrLf + N''')'''
      END
  ;
END

SET @SelectStatement = N'SELECT'
  + CASE WHEN NULLIF(@TopExpression,N'') IS NOT NULL
    THEN N' TOP ' + @TopExpression
    ELSE N'' END
  + @CrLf + @SelectList + @CrLf
  + N'FROM ' + @ObjectName
  + CASE WHEN NULLIF(@FunctionParameters,N'') IS NOT NULL
    THEN @FunctionParameters
    ELSE N'' END
  + CASE WHEN NULLIF(@SearchCondition,N'') IS NOT NULL
    THEN @CrLf + N'WHERE ' + @SearchCondition
    ELSE N'' END
  + CASE WHEN NULLIF(@OrderByExpression,N'') IS NOT NULL
    THEN @CrLf + N'ORDER BY ' + @OrderByExpression
    ELSE N'' END
  + @CrLf + N';' + @CrLf + @CrLf
;

IF @Debug = 1
BEGIN
  PRINT(@CrLf + N'--Select statement');
  PRINT(@SelectStatement);
END

INSERT INTO @TableData
EXECUTE (@SelectStatement);

IF @GenerateProjectInfo = 1
BEGIN
  INSERT INTO @Results
  SELECT N'--INSERTs generated by GenerateInsert (Build 6)'
  UNION SELECT N'--Project page: http://github.com/drumsta/sql-generate-insert'
END

IF @GenerateSetNoCount = 1
BEGIN
  INSERT INTO @Results
  SELECT N'SET NOCOUNT ON'
END

IF @PopulateIdentityColumn = 1
BEGIN
  INSERT INTO @Results
  SELECT N'SET IDENTITY_INSERT ' + COALESCE(@TargetObjectName,@ObjectName) + N' ON'
END

IF @GenerateSingleInsertPerRow = 1
BEGIN
  INSERT INTO @Results
  SELECT TableRow
  FROM @TableData
END ELSE BEGIN
  IF @FormatCode = 1
  BEGIN
    INSERT INTO @Results
    SELECT @InsertSql;

    IF @OmmitInsertColumnList != 1
    BEGIN
      INSERT INTO @Results
      SELECT N'(' + @ColumnList + N')';
    END

    IF @UseSelectSyntax != 1
    BEGIN
      INSERT INTO @Results
      SELECT N'VALUES';
    END
  END ELSE BEGIN
    INSERT INTO @Results
    SELECT @InsertSql
      + CASE WHEN @OmmitInsertColumnList = 1 THEN N'' ELSE N' (' + @ColumnList + N')' END
      + CASE WHEN @UseSelectSyntax = 1 THEN N'' ELSE N' VALUES' END
  END

  SET @RowNo = 0;
  DECLARE DataCursor CURSOR LOCAL FAST_FORWARD FOR
  SELECT TableRow
  FROM @TableData
  FOR READ ONLY
  ;
  OPEN DataCursor;
  FETCH NEXT FROM DataCursor INTO @TableRow;

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @RowNo = @RowNo + 1;

    INSERT INTO @Results
    SELECT
      CASE WHEN @UseSelectSyntax = 1
      THEN CASE WHEN @RowNo > 1 THEN N'UNION' + CASE WHEN @FormatCode = 1 THEN @CrLf ELSE N' ' END ELSE N'' END
      ELSE CASE WHEN @RowNo > 1 THEN N',' ELSE N' ' END END
      + @TableRow;

    FETCH NEXT FROM DataCursor INTO @TableRow;
  END

  CLOSE DataCursor;
  DEALLOCATE DataCursor;

  IF @GenerateStatementTerminator = 1
  BEGIN
    INSERT INTO @Results
    SELECT N';';
  END

  IF @GenerateGo = 1
  BEGIN
    INSERT INTO @Results
    SELECT N'GO';
  END
END

IF @PopulateIdentityColumn = 1
BEGIN
  INSERT INTO @Results
  SELECT N'SET IDENTITY_INSERT ' + COALESCE(@TargetObjectName,@ObjectName) + N' OFF'
END

IF @FormatCode = 1
BEGIN
  INSERT INTO @Results
  SELECT N''; -- An empty line at the end
END

IF @PrintGeneratedCode = 1
BEGIN
  DECLARE @LongRows bigint;
  SET @LongRows = (SELECT COUNT(*) FROM @Results WHERE LEN(TableRow) > 4000);

  IF @LongRows > 0
    AND @ShowWarnings = 1
  BEGIN
    PRINT(N'--*************************');
    IF @LongRows = 1
      PRINT(N'--WARNING: ' + CONVERT(nvarchar(max), @LongRows) + N' Row is very long and will be chopped at every 4000 character.')
    ELSE
      PRINT(N'--WARNING: ' + CONVERT(nvarchar(max), @LongRows) + N' Rows are very long and will be chopped at every 4000 character.');
    PRINT(N'-- If this is an issue then the workaround is to use @PrintGeneratedCode = 0 and output "Result to Grid" in SSMS.');
    PRINT(N'--*************************');
  END

  DECLARE ResultsCursor CURSOR LOCAL FAST_FORWARD FOR
  SELECT TableRow
  FROM @Results
  FOR READ ONLY
  ;
  OPEN ResultsCursor;
  FETCH NEXT FROM ResultsCursor INTO @TableRow;

  WHILE @@FETCH_STATUS = 0
  BEGIN
    -- The following code is a workaround because the PRINT(@TableRow) has limit of 4,000 Unicode characters,
    --   and longer strings are truncated.
    -- It still has a con, the lines are chopped at every 4000 character, however at least everything is printed out.
    -- http://stackoverflow.com/questions/7850477/how-to-print-varcharmax-using-print-statement
    -- The workaround would be to use @PrintGeneratedCode = 0 and output "Result to Grid" in SSMS.
    DECLARE @CurrentEnd bigint; -- track the length of the next sub-string
    DECLARE @Offset tinyint; -- tracks the amount of offset needed
    SET @TableRow = REPLACE(REPLACE(@TableRow, CHAR(13) + CHAR(10), CHAR(10)), CHAR(13), CHAR(10));

    WHILE LEN(@TableRow) > 1
    BEGIN
      IF CHARINDEX(CHAR(10), @TableRow) BETWEEN 1 AND 4000
      BEGIN
        SET @CurrentEnd = CHARINDEX(CHAR(10), @TableRow) - 1;
        SET @Offset = 2;
      END
      ELSE
      BEGIN
        SET @CurrentEnd = 4000;
        SET @Offset = 1;
      END

      PRINT(SUBSTRING(@TableRow, 1, @CurrentEnd));
      SET @TableRow = SUBSTRING(@TableRow, @CurrentEnd + @Offset, LEN(@TableRow))   
    END

    FETCH NEXT FROM ResultsCursor INTO @TableRow;
  END

  CLOSE ResultsCursor;
  DEALLOCATE ResultsCursor;
END ELSE BEGIN
  SELECT *
  FROM @Results;
END

END
