-- =============================================
-- Author:		Matt Winston
-- Create date: 11/8/24
-- Description:	Averages of NCSF_V2 ordered by Category and Sub-category for CF reporting.
-- =============================================
CREATE PROCEDURE [dbo].[usp_CF_Score_Overall]
	@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 --declare @Assessment_Id int
	 --set @Assessment_Id = 1020
   select avg(Answer_Value) as Average
	from ( 
		select a.Assessment_Id, r.Standard_Category, r.Standard_Sub_Category, 
		cast(case when a.Answer_Text = 'U' then 0 else a.Answer_Text end as float) as Answer_Value
		from NEW_REQUIREMENT r 
		join REQUIREMENT_SETS s on r.Requirement_Id = s.Requirement_Id
		join ANSWER a on s.Requirement_Id = a.Question_Or_Requirement_Id and a.Is_Requirement = 1
		where s.Set_Name = 'NCSF_V2' and a.Assessment_Id = @Assessment_Id
	) as ta
	
END






