-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getStandardsSummary]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	/*
TODO this needs to take into account requirements vs questions
get the question set then for all the questions take the total risk (in this set only)
then calculate the total risk in each question_group_heading(category) 
then calculate the actual percentage of the total risk in each category 
order by the total
*/
declare @applicationMode nvarchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
if(@ApplicationMode = 'Questions Based')	
begin	
		select a.Answer_Full_Name, a.Short_Name, a.Answer_Text, 
			isnull(m.qc,0) as [qc],
			isnull(m.Total,0) as [Total], 
			isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int),0) as [Percent] 
		from (select Short_Name,l.Answer_Full_Name,l.Answer_Text from AVAILABLE_STANDARDS a 
		join SETS s on a.Set_Name = s.Set_Name
		, ANSWER_LOOKUP l
		where a.Assessment_Id = @assessment_id) a left join (
		SELECT ms.Short_Name, a.Answer_Text, isnull(count(c.question_id),0) qc, SUM(count(c.question_id)) OVER(PARTITION BY Short_Name) AS Total
				FROM Answer_Questions a 
				join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id				
				join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
				join [sets] ms on s.Set_Name = ms.Set_Name
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id 
				join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
				join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
				where a.Assessment_Id = @assessment_id and v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
				group by ms.Short_Name, a.Answer_Text
		) m on a.Answer_Text = m.Answer_Text AND a.Short_Name = m.Short_Name
		order by Short_Name
end
else 
begin 
		select a.Answer_Full_Name, a.Short_Name, a.Answer_Text,
			isnull(m.[qc], 0) as [qc], 
			isnull(m.[Total], 0) as [Total],
			isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int),0) as [Percent] 
		from (select Short_Name,l.Answer_Full_Name,l.Answer_Text from AVAILABLE_STANDARDS a 
		join SETS s on a.Set_Name = s.Set_Name
		, ANSWER_LOOKUP l
		where a.Assessment_Id = @assessment_id) a left join (
		SELECT ms.Short_Name, a.Answer_Text, isnull(count(c.Requirement_Id),0) qc, SUM(count(c.Requirement_Id)) OVER(PARTITION BY Short_Name) AS Total  
				FROM Answer_Requirements a 
				join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id = c.Requirement_Id				
				join REQUIREMENT_SETS s on c.Requirement_Id = s.Requirement_Id		
				join [sets] ms on s.Set_Name = ms.Set_Name		
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 			
				join REQUIREMENT_LEVELS rl on c.Requirement_Id = rl.Requirement_Id									
				join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
				join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
				where a.Assessment_Id = @assessment_id and v.Selected = 1 and v.Assessment_Id = @assessment_id and rl.Standard_Level = ul.Universal_Sal_Level
				group by ms.Short_Name, a.Answer_Text
	   ) m on a.Answer_Text = m.Answer_Text AND a.Short_Name = m.Short_Name
	   order by Short_Name
end
END







