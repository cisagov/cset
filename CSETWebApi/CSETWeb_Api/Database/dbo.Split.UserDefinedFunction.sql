USE [CSETWeb]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 11/14/2018 3:57:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split](@string VARCHAR(500))
RETURNS @TableValues TABLE (Value nvarchar(4000),Id bigint identity(1,1))
AS
BEGIN
declare @pos int
declare @piece varchar(500)
DECLARE @id INT
SET @id = 1

-- Need to tack a delimiter onto the end of the input string if one doesn’t exist
if right(rtrim(@string),1) <> ','
 set @string = @string  + ','

set @pos =  patindex('%,%' , @string)
while @pos <> 0
begin
 set @piece = left(@string, @pos - 1)
 
 -- You have a piece of data, so insert it, print it, do whatever you want to with it.
 INSERT @TableValues
         ( Value)
 VALUES  ( @piece)
SET @id=@id +1            

 set @string = stuff(@string, 1, @pos, '')
 set @pos =  patindex('%,%' , @string)
END
RETURN 
END 
GO
