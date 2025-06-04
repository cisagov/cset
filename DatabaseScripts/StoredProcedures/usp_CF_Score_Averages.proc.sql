-- =============================================
-- Author:		Matt Winston
-- Create date: 11/8/24
-- Description:	Averages of NCSF_V2 ordered by Category and Sub-category for CF reporting.
-- =============================================
CREATE PROCEDURE 
[dbo].[usp_CF_Score_Averages]
	@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 --declare @Assessment_Id int
   select a.Standard_Category, a.Standard_Sub_Cat
egory, cast(Average as decimal(10, 2)) as Average, cast(AVG(Average) OVER(PARTITION BY a.standard_category) as decimal(10,2)) AS groupAvg, b.rseq from (
	select ta.Standard_Category, Standard_Sub_Category, avg(Adjusted_Answer_Value) as Average
	from ( 
		
select *, case when temp.Answer_Value > 5 then (case when temp.Answer_Value = 6 then temp.Answer_Value - 0.5 else temp.Answer_Value - 1 end) else temp.Answer_Value end as Adjusted_Answer_Value from (
			select a.Assessment_Id, r.Standard_Category, r.Stand
ard_Sub_Category, 
			cast(case when a.Answer_Text = 'U' then 0 else a.Answer_Text end as float) as Answer_Value
			from NEW_REQUIREMENT r 
			join REQUIREMENT_SETS s on r.Requirement_Id = s.Requirement_Id
			join ANSWER a on s.Requirement_Id = a.Question
_Or_Requirement_Id and a.Is_Requirement = 1
			where s.Set_Name = 'NCSF_V2' and a.Assessment_Id = @Assessment_Id
		) as temp
	) as ta
	group by Standard_Category, Standard_Sub_Category
) as a
join (
	select distinct Standard_Category,Standard_Sub_Category
,min(requirement_sequence) rseq
	from NEW_REQUIREMENT r 
	join REQUIREMENT_SETS s on r.Requirement_Id = s.Requirement_Id
	where s.Set_Name = 'NCSF_V2'
	group by standard_category, standard_sub_category
) as b on a.Standard_Category = b.Standard_Category a
nd a.Standard_Sub_Category = b.Standard_Sub_Category
order by rseq
END
