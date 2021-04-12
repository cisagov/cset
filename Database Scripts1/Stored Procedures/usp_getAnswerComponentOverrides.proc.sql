-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getAnswerComponentOverrides]
	@assessment_id int
AS
BEGIN
	IF OBJECT_ID('tempdb..##componentExploded') IS NOT NULL DROP TABLE #componentExploded
	create table #componentExploded (UniqueKey int, Assessment_Id int, Answer_Id int, Question_Id int, Answer_Text varchar(50), Comment varchar(2048),
		Alternate_JustificaTion ntext, FeedBack varchar(2048), Question_Number int, QuestionText varchar(7338), ComponentName varchar(200), Symbol_Name varchar(100),
		Question_Group_Heading nvarchar(250), GroupHeadingId int, Universal_Sub_Category varchar(100), SubCategoryId int, Is_Component bit, Component_Guid uniqueidentifier,
		Layer_Id int, LayerName varchar(250),Container_Id int, ZoneName varchar(250), SAL varchar(20), Mark_For_Review bit, Is_Requirement bit,
		Is_Framework bit, Reviewed bit, Simple_Question varchar(7338), Sub_Heading_Question_Description varchar(200), heading_pair_id int,
		label varchar(200), Component_Symbol_Id int)
	insert into #componentExploded exec [usp_getExplodedComponent] @assessment_id

	SELECT [UniqueKey]
      ,[Assessment_Id]
      ,[Answer_Id]
      ,[Question_Id]
      ,[Answer_Text]
      ,[Comment]
      ,[Alternate_Justification]
      ,[Question_Number]
      ,[QuestionText]
      ,[ComponentName]
      ,[Symbol_Name]
      ,[Question_Group_Heading]
      ,[GroupHeadingId]
      ,[Universal_Sub_Category]
      ,[SubCategoryId]
      ,[Is_Component]
      ,[Component_Guid]
      ,[Layer_Id]
      ,[LayerName]
      ,[Container_Id]
      ,[ZoneName]
      ,[SAL]
      ,[Mark_For_Review]
      ,[Is_Requirement]
      ,[Is_Framework]
      ,[Reviewed]
      ,[Simple_Question]
      ,[Sub_Heading_Question_Description]
      ,[heading_pair_id]
      ,[label]
      ,[Component_Symbol_Id]
	  ,[FeedBack]
  FROM #componentExploded where Answer_Id is not null

END
