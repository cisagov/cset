
-- =============================================
-- Author:		Barry Hansen
-- Create date: 2/18/2021
-- Description:	copy a base set into an existing custom set
-- =============================================
CREATE PROCEDURE [dbo].[usp_CopyIntoSet]
	-- Add the parameters for the stored procedure here
	@SourceSetName nvarchar(50),
	@DestinationSetName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--check to make sure the destination set is a custom set
	--cannot modify existing standards
	if exists (select * from sets where Set_Name = @DestinationSetName and Is_Custom = 0)
	begin
		raiserror('Destination set is not a custom set.  Standard sets cannot be modified.',18,1);
		return 
	end

    -- Insert statements for procedure here
	insert CUSTOM_STANDARD_BASE_STANDARD (Custom_Questionaire_Name,Base_Standard) values(@DestinationSetName,@SourceSetName)
	--do the headers first
	INSERT INTO [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]
			   ([Sub_Heading_Question_Description]
			   ,[Question_Group_Heading_Id]
			   ,[Universal_Sub_Category_Id]
			   ,[Set_Name])
	select a.* from
	(select [Sub_Heading_Question_Description]
			   ,[Question_Group_Heading_Id]
			   ,[Universal_Sub_Category_Id]
			   ,@DestinationSetName as [Set_Name] from UNIVERSAL_SUB_CATEGORY_HEADINGS
	where Set_Name = @SourceSetName ) a 
	left join (select [Sub_Heading_Question_Description]
			   ,[Question_Group_Heading_Id]
			   ,[Universal_Sub_Category_Id]
			   ,@DestinationSetName as [Set_Name] from UNIVERSAL_SUB_CATEGORY_HEADINGS
	where Set_Name = @DestinationSetName ) b on a.Question_Group_Heading_Id=b.Question_Group_Heading_Id
	and a.Universal_Sub_Category_Id = b.Universal_Sub_Category_Id
	where b.Question_Group_Heading_Id is not null

	INSERT INTO [dbo].[NEW_REQUIREMENT]
           ([Requirement_Title]
           ,[Requirement_Text]
           ,[Supplemental_Info]
           ,[Standard_Category]
           ,[Standard_Sub_Category]
           ,[Weight]
           ,[Implementation_Recommendations]
           ,[Original_Set_Name]
           ,[NCSF_Cat_Id]
           ,[NCSF_Number]
           ,[Ranking]
           ,[Question_Group_Heading_Id]
           ,[ExaminationApproach]
           ,[Old_Id_For_Copy])
	select 		
		Requirement_Title,
		Requirement_Text,
		Supplemental_Info,
		Standard_Category,
		Standard_Sub_Category,
		Weight,
		Implementation_Recommendations,
		Original_Set_Name = @DestinationSetName,
		NCSF_Cat_Id,
		NCSF_Number,
		Ranking,
		Question_Group_Heading_Id,
		ExaminationApproach,
		r.Requirement_Id as Old_Id_For_Copy
		from REQUIREMENT_SETS s
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id	
	where set_name = @SourceSetName
	order by Requirement_Sequence

	INSERT INTO [dbo].[REQUIREMENT_SETS]
           ([Requirement_Id]
           ,[Set_Name]
           ,[Requirement_Sequence])
	select nr.Requirement_Id,Set_name = @DestinationSetName,ns.Requirement_Sequence from NEW_REQUIREMENT nr 
	join (select s.Requirement_Id,s.Requirement_Sequence,s.Set_Name 
		from NEW_REQUIREMENT r join REQUIREMENT_SETS s on r.Requirement_Id=s.Requirement_Id 
		where s.Set_Name = @SourceSetName) ns on nr.Old_Id_For_Copy=ns.Requirement_Id
	where Original_Set_Name = @DestinationSetName

	insert into REQUIREMENT_LEVELS (Requirement_Id,Level_Type,Standard_Level)
	select a.Requirement_Id,b.Level_Type,b.Standard_Level from (
	select r.* from REQUIREMENT_SETS s join NEW_REQUIREMENT r
	on s.Requirement_Id = r.Requirement_Id
	where s.Set_Name = @DestinationSetName) a join (	
	select l.* from requirement_levels l 
	join REQUIREMENT_SETS s on l.Requirement_Id=s.Requirement_Id	
	where s.Set_Name = @SourceSetName) b on a.Old_Id_For_Copy=b.Requirement_Id


	insert into REQUIREMENT_QUESTIONS_SETS (Question_Id,Requirement_Id,Set_Name)
	select b.Question_Id,b.Requirement_Id,set_name = @DestinationSetName from REQUIREMENT_QUESTIONS_SETS a right join (
	select question_id,r.Requirement_Id
		from REQUIREMENT_QUESTIONS_SETS s
		join (select * from NEW_REQUIREMENT where Original_Set_Name= @DestinationSetName) r on s.Requirement_Id=r.Old_Id_For_Copy
		where set_name = @SourceSetName) b on a.Question_Id=b.Question_Id and a.Set_Name=@DestinationSetName
	where a.Question_Id is null

	
	INSERT INTO [dbo].[NEW_QUESTION_SETS]
           ([Set_Name]
           ,[Question_Id])    
	select a.set_name,a.Question_Id from (
	select set_name = @DestinationSetName,question_id
	from NEW_QUESTION_SETS where Set_Name = @SourceSetName) a 
	left join NEW_QUESTION_SETS b on a.Question_Id=b.Question_Id and a.set_name=b.Set_Name
	where b.Question_Id is null

	--insert the question sets records then join that with the old 
	--question sets records 		
	INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([New_Question_Set_Id],[Universal_Sal_Level])                
	select distinct b.New_Question_Set_Id,l.Universal_Sal_Level
	from NEW_QUESTION_SETS s
	join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
	join (select ss.Question_Id,ss.New_Question_Set_Id 
	from NEW_QUESTION_SETS ss
		left join NEW_QUESTION_LEVELS ls on ss.New_Question_Set_Id=ls.New_Question_Set_Id
		where set_name = @DestinationSetName and ls.New_Question_Set_Id is null) b on s.Question_Id=b.Question_Id 
	where s.Set_Name = @SourceSetName


END
