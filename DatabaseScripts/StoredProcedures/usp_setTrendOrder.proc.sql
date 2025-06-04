-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_setTrendOrder]
	-- Add the parameters for the stored procedure here
	@Aggregation_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @assessment_id int, @i int
	

	declare me cursor for 
	select aa.Assessment_Id from AGGREGATION_ASSESSMENT aa
	join ASSESSMENTS a on aa.Assessment_Id = a.Assessment_Id
	where Aggregation_Id = @Aggregation_id
	order by a.Assessment_Date
	
	open me

	fetch next from me into @assessment_id
	set @i = 0;
	while(@@FETCH_STATUS = 0)
	begin
	update AGGREGATION_ASSESSMENT set Sequence = @i where Assessment_Id = @assessment_id and Aggregation_Id=@Aggregation_id
	set @i= @i+1
	fetch next from me into @assessment_id
	end 
	close me 
	deallocate me    
END
