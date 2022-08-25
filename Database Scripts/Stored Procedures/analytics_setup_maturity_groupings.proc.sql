-- =============================================
-- Author:		hansbk
-- Create date: 3/31/2022
-- Description:	setup for analytics.  This stored proces creates a global temporary
-- table that contains the categories to group by for each maturity model. 
-- the stored proc should look to see if the temporary table exists if it does then 
-- we don't need to do anything if it does not then we should build the temp table
-- =============================================
CREATE PROCEDURE [dbo].[analytics_setup_maturity_groupings]
AS
BEGIN
	SET NOCOUNT ON;
	/*
	clean out the table and rebuild it
	go through the maturity models table and for each one select the appropriate level 
	of maturity grouping (make sure they are distinct)
	into the temp table
	*/
delete from analytics_maturity_Groupings

declare @maturity_model_id int, @analytics_rollup_level int


DECLARE maturity_cursor CURSOR FOR   
SELECT Maturity_Model_Id,Analytics_Rollup_Level 
FROM MATURITY_MODELS
  
OPEN maturity_cursor  
  
FETCH NEXT FROM maturity_cursor   
INTO @maturity_model_id, @analytics_rollup_level
  
WHILE @@FETCH_STATUS = 0  
BEGIN      
	INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] ([Maturity_Model_Id],[Maturity_Question_Id],[Question_Group])
	select distinct g.Maturity_Model_Id,q.Mat_Question_Id, title 
	from MATURITY_GROUPINGS g join MATURITY_QUESTIONS q on g.Grouping_Id=q.Grouping_Id 
	where q.Maturity_Model_Id = @maturity_model_id and g.Maturity_Model_Id=@maturity_model_id 
	and Group_Level = @analytics_rollup_level
    
    FETCH NEXT FROM maturity_cursor   
    into @maturity_model_id, @analytics_rollup_level
END   
CLOSE maturity_cursor;  
DEALLOCATE maturity_cursor;  

	
END
