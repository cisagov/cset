USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetOverallRankedCategoriesPage]    Script Date: 11/14/2018 3:57:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetOverallRankedCategoriesPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@assessment_id = null)
	select Question_Group_Heading='Information and Document Management',qc=5,
		cr=4827,Total=487078,nuCount=5,Actualcr=4827,prc=0.99101170654300,[Percent]=1.12


    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getOverallRankedCategories] @assessment_id

END
GO
