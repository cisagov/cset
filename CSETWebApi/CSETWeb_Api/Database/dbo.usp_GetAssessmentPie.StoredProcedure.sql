USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAssessmentPie]    Script Date: 11/14/2018 3:57:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		barry
-- Create date: 7/20/2018
-- Description:	returns the top level pie chart data
-- for an assessment
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetAssessmentPie]	
    @Assessment_Id int	
AS
BEGIN	
	SET NOCOUNT ON;
select l.Answer_Text,l.Answer_Full_Name,isnull(b.vcount,0) vcount, isnull(b.value,0) [value] from ANSWER_LOOKUP l left join (
select Answer_Text,count(answer_text) vcount, cast((count(answer_text) * 100.0)/sum(count(*)) over() as decimal(18,1)) [value] from  ANSWER 
where assessment_id = @Assessment_Id
group by answer_text) b on l.Answer_Text = b.Answer_Text
END
GO
