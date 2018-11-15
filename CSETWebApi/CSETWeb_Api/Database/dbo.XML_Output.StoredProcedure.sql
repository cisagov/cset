USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[XML_Output]    Script Date: 11/14/2018 3:57:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Scott Cook
-- Create date: 11/6/14
-- Description:	This Stored Procedure extracts Assessment data in an XML format and stores it in an XML file.
-- =============================================
CREATE PROCEDURE [dbo].[XML_Output](
                                   @dbName NVARCHAR(1000)
                                  )

AS
BEGIN
	CREATE TABLE #XMLTemp
	(
		Id int primary key identity,
		Data VARCHAR(MAX)
	)
/*
	DECLARE @XMLTemp TABLE
	(
		Id int primary key identity,
		Data VARCHAR(4000)
	)
*/
	DECLARE @ResultVar XML
	DECLARE @XMLString VARCHAR(MAX)
	DECLARE @DataStr VARCHAR(MAX)
	DECLARE @indent INT
	DECLARE @strtX BIGINT
	DECLARE @endX BIGINT
	DECLARE @prevStrt BIGINT
	DECLARE @endTag BIT
	DECLARE @qry    NVARCHAR(4000)
	DECLARE @ParameterList NVARCHAR(100)
	DECLARE @XMLCategory VARCHAR(100)

--    SET @dbName = (select TOP 1 name from Sys.Databases where UPPER(name) like '%CSET_CONTROL%')
--    SET @dbName = '[' + @dbName + ']'

    IF LEFT(@dbName, 1) <> '['
	  SET @dbName = '[' + @dbName
	IF RIGHT(@dbName, 1) <> ']'
	  SET @dbName = @dbName + ']'

    INSERT #XMLTemp VALUES('<ASSESSMENT>')
	SET @indent = 2

-- Get the CSET Version data
	SET @XMLCategory = 'CSET_VERSION'
	SET @qry =      'select Version_Id, Cset_Version '
	SET @qry = @qry + 'from ' + @dbName + '.[dbo].[CSET_VERSION] ' + @XMLCategory + ' for XML AUTO, ELEMENTS'
    SET @qry = N'set @ResultVar = (' + @qry + ')'

    SET @XMLString = ''
    SET @ResultVar = ''
	EXECUTE sp_executesql @qry, N'@ResultVar XML OUTPUT', @ResultVar OUTPUT
    SET @XMLString = CONVERT(VARCHAR(MAX), @ResultVar)

	IF LEN(@XMLString) > 0
	  BEGIN
	    SET @strtX = 1
		SET @endX = 1

	    WHILE @endX < LEN(@XMLString)
		  BEGIN
		    SET @endTag = 0
            EXEC [dbo].[Parse_XML] @XMLString, @strtX, @endX OUTPUT, @DataStr OUTPUT

			IF (@DataStr = '<' + @XMLCategory + '>') OR (@DataStr = '</' + @XMLCategory + '>')
			  SET @indent = 2
			ELSE
			  SET @indent = 4

            SET @DataStr = SPACE(@indent) + @DataStr
			INSERT #XMLTemp VALUES(@DataStr)
			
			SET @strtX = @endX
		  END
	  END
--select 'CSET_VERSION Complete'

-- Get the DOCUMENT_FILE data
	SET @XMLCategory = 'DOCUMENT_FILE'
	SET @qry =      'select Document_Id, Path, Title '
	SET @qry = @qry + 'from ' + @dbName + '.[dbo].[DOCUMENT_FILE] ' + @XMLCategory + ' for XML AUTO, ELEMENTS'
    SET @qry = N'set @ResultVar = (' + @qry + ')'

    SET @XMLString = ''
    SET @ResultVar = ''
	EXECUTE sp_executesql @qry, N'@ResultVar XML OUTPUT', @ResultVar OUTPUT
    SET @XMLString = CONVERT(VARCHAR(MAX), @ResultVar)

	IF LEN(@XMLString) > 0
	  BEGIN
	    SET @strtX = 1
		SET @endX = 1

	    WHILE @endX < LEN(@XMLString)
		  BEGIN
		    SET @endTag = 0
            EXEC [dbo].[Parse_XML] @XMLString, @strtX, @endX OUTPUT, @DataStr OUTPUT

			IF (@DataStr = '<' + @XMLCategory + '>') OR (@DataStr = '</' + @XMLCategory + '>')
			  SET @indent = 2
			ELSE
			  SET @indent = 4

            SET @DataStr = SPACE(@indent) + @DataStr
			INSERT #XMLTemp VALUES(@DataStr)
			
			SET @strtX = @endX
		  END
	  END
--select 'DOCUMENT_FILE Complete'

-- Get the Assessment Information table data
	SET @XMLCategory = 'INFORMATION'
	SET @qry =      'select i.Assessment_Name, i.Assessment_Date, i.Facility_Name, i.City_Or_Site_Name, i.State_Province_Or_Region, i.Assessor_Name'
	SET @qry = @qry +    ', i.Assessor_Email, i.Assessor_Phone, i.Assessment_Description, i.Additional_Notes_And_Comments, i.Additional_Contacts'
	SET @qry = @qry +    ', i.Executive_Summary, i.Enterprise_Evaluation_Summary, i.Real_Property_Unique_Id, df.Document_Id, df.Path, df.Title '
	SET @qry = @qry + 'from ' + @dbName + '.[dbo].[INFORMATION] i '
	SET @qry = @qry + 'left join ' + @dbName + '.[dbo].[DOCUMENT_FILE] df on i.eMass_Document_Id = df.Document_Id '
	SET @qry = @qry +  'for XML PATH(''' + @XMLCategory + '''), ELEMENTS'
    SET @qry = N'set @ResultVar = (' + @qry + ')'

    SET @XMLString = ''
    SET @ResultVar = ''
	EXECUTE sp_executesql @qry, N'@ResultVar XML OUTPUT', @ResultVar OUTPUT
    SET @XMLString = CONVERT(VARCHAR(MAX), @ResultVar)
	IF LEN(@XMLString) > 0
	  BEGIN
	    SET @strtX = 1
		SET @endX = 1

	    WHILE @endX < LEN(@XMLString)
		  BEGIN
		    SET @endTag = 0
            EXEC [dbo].[Parse_XML] @XMLString, @strtX, @endX OUTPUT, @DataStr OUTPUT

			IF (@DataStr = '<' + @XMLCategory + '>') OR (@DataStr = '</' + @XMLCategory + '>')
			  SET @indent = 2
			ELSE
			  SET @indent = 4

            SET @DataStr = SPACE(@indent) + @DataStr
			INSERT #XMLTemp VALUES(@DataStr)

			SET @strtX = @endX
		  END
	  END
--select 'INFORMATION Complete'

-- Get the Assessment New_Question/Answer table data
	SET @XMLCategory = 'QUESTION_ANSWER'
	SET @qry =       'select a.Mark_For_Review, a.Comment, a.Alternate_Justification, a.Question_Number, a.Answer_Text, a.Component_Guid'
	SET @qry = @qry +     ', a.Is_Component, a.Custom_Question_Guid, a.Is_Framework, docs.Document_Id, docs.Path, docs.Title'
	SET @qry = @qry +  '   , nq.Question_Id, nq.Simple_Question, nq.Universal_Sal_Level, nq.Universal_Sub_Category '
    SET @qry = @qry +  'from ' + @dbName + '.[dbo].[ANSWER] a '
    SET @qry = @qry +  'left join (Select da.Document_Id, da.Question_Or_Requirement_Id, da.Component_Id, da.Is_Requirement, df.Path, df.Title '
	SET @qry = @qry +              'from ' + @dbName + '.[dbo].[DOCUMENT_ANSWERS] da join ' + @dbName + '.[dbo].[DOCUMENT_FILE] df '
	SET @qry = @qry +                'on da.Document_Id = df.Document_Id) docs '
	SET @qry = @qry +    'on a.Is_Requirement = docs.Is_Requirement and a.Question_Or_Requirement_Id = docs.Question_Or_Requirement_Id '
	SET @qry = @qry +   'and a.Component_Id = docs.Component_Id '
    SET @qry = @qry +  'join [dbo].[NEW_QUESTION] nq on a.Question_Or_Requirement_Id = nq.Question_Id '
    SET @qry = @qry + 'where a.Is_Requirement = 0 for XML PATH(''' + @XMLCategory + '''), ELEMENTS'
    SET @qry = N'set @ResultVar = (' + @qry + ')'

    SET @XMLString = ''
    SET @ResultVar = ''
	EXECUTE sp_executesql @qry, N'@ResultVar XML OUTPUT', @ResultVar OUTPUT
    SET @XMLString = CONVERT(VARCHAR(MAX), @ResultVar)

	IF LEN(@XMLString) > 0
	  BEGIN
	    SET @strtX = 1
		SET @endX = 1
		SET @prevStrt = 1

	    WHILE @endX < LEN(@XMLString)
		  BEGIN
		    SET @prevStrt = @strtX
		    SET @endTag = 0
            EXEC [dbo].[Parse_XML] @XMLString, @strtX, @endX OUTPUT, @DataStr OUTPUT

			IF (@DataStr = '<' + @XMLCategory + '>') OR (@DataStr = '</' + @XMLCategory + '>')
			  SET @indent = 2
			ELSE
			  SET @indent = 4

            SET @DataStr = SPACE(@indent) + @DataStr
			INSERT #XMLTemp VALUES(@DataStr)

			SET @strtX = @endX
			IF @strtX <= @prevStrt
			  BREAK
		  END
	  END
--select 'NEW_QUESTION Complete'

-- Get the Assessment New_Requirment/Answer table data
	SET @XMLCategory = 'REQUIREMENT_ANSWER'
	SET @qry =       'select a.Mark_For_Review, a.Comment, a.Alternate_Justification, a.Question_Number, a.Answer_Text, a.Component_Guid'
	SET @qry = @qry +     ', a.Is_Component, a.Custom_Question_Guid, a.Is_Framework, docs.Document_Id, docs.Path, docs.Title'
	SET @qry = @qry +     ', nr.Requirement_Id, nr.Requirement_Text, nr.Default_Standard_Level, nr.Standard_Category '
    SET @qry = @qry +     ', nc.NCSF_Cat_Id, nc.NCSF_Function_Id, nc.NCSF_Category_Id, nc.NCSF_Category_Name, nc.NCSF_Category_Description'
	SET @qry = @qry +     ', nf.NCSF_Function_Name, nf.NCSF_Function_order '
    SET @qry = @qry +     ', (select Page_Number, Destination_String '
    SET @qry = @qry +             ', (select File_Name, Title, Name '
	SET @qry = @qry +                  'from [dbo].[GEN_FILE] GEN_FILE '
	SET @qry = @qry +	              'where REQUIREMENT_SOURCE_FILES.Gen_File_Id = GEN_FILE.Gen_File_Id for XML AUTO, TYPE, ELEMENTS) '
    SET @qry = @qry +          'from [dbo].[REQUIREMENT_SOURCE_FILES] REQUIREMENT_SOURCE_FILES '
    SET @qry = @qry +         'where REQUIREMENT_SOURCE_FILES.Requirement_Id = nr.Requirement_Id for XML AUTO, TYPE, ELEMENTS) '
    SET @qry = @qry +  'FROM ' + @dbName + '.[dbo].[ANSWER] a '
    SET @qry = @qry +  'left join (Select da.Document_Id, da.Question_Or_Requirement_Id, da.Component_Id, da.Is_Requirement, df.Path, df.Title '
	SET @qry = @qry +               'from ' + @dbName + '.[dbo].[DOCUMENT_ANSWERS] da join ' + @dbName + '.[dbo].[DOCUMENT_FILE] df '
	SET @qry = @qry +                 'on da.Document_Id = df.Document_Id) docs '
	SET @qry = @qry +    'on a.Is_Requirement = docs.Is_Requirement and a.Question_Or_Requirement_Id = docs.Question_Or_Requirement_Id '
	SET @qry = @qry +   'and a.Component_Id = docs.Component_Id '
    SET @qry = @qry +  'join [dbo].[NEW_REQUIREMENT] nr on a.Question_Or_Requirement_Id = nr.Requirement_Id '
    SET @qry = @qry +  'left join [dbo].[NCSF_CATEGORY] nc on nr.NCSF_Cat_Id=nc.NCSF_Cat_Id '
    SET @qry = @qry +  'left join [dbo].[NCSF_FUNCTIONS] nf on nc.NCSF_Function_Id=nf.NCSF_Function_ID '
    SET @qry = @qry + 'where a.Is_Requirement = 1 for XML PATH(''' + @XMLCategory + '''), ELEMENTS'
    SET @qry = N'set @ResultVar = (' + @qry + ')'

    SET @XMLString = ''
    SET @ResultVar = ''
	EXECUTE sp_executesql @qry, N'@ResultVar XML OUTPUT', @ResultVar OUTPUT
    SET @XMLString = CONVERT(VARCHAR(MAX), @ResultVar)

	IF LEN(@XMLString) > 0
	  BEGIN
	    SET @strtX = 1
		SET @endX = 1
		SET @prevStrt = 1

	    WHILE @endX < LEN(@XMLString)
		  BEGIN
		    SET @prevStrt = @strtX
		    SET @endTag = 0
            EXEC [dbo].[Parse_XML] @XMLString, @strtX, @endX OUTPUT, @DataStr OUTPUT

			IF (@DataStr = '<' + @XMLCategory + '>') OR (@DataStr = '</' + @XMLCategory + '>')
			  SET @indent = 2
			ELSE
			  SET @indent = 4

            SET @DataStr = SPACE(@indent) + @DataStr
			INSERT #XMLTemp VALUES(@DataStr)

			SET @strtX = @endX
			IF @strtX <= @prevStrt
			  BREAK
		  END
	  END
--select 'NEW_REQUIREMENT Complete'

-- Get the Assessment SUB_CATEGORY_ANSWERS table data
	SET @XMLCategory = 'SUB_CATEGORY_ANSWERS'
	SET @qry =       ' select cats.Question_Group_Heading_Id, cats.Universal_Sub_Category_Id, cats.Sub_Heading_Question_Description, sca.Answer_Text,'
	SET @qry = @qry +     ' sca.Component_Id, sca.Is_Component'
    SET @qry = @qry +  ' from ' + @dbName + '.[dbo].[SUB_CATEGORY_ANSWERS] sca '
    SET @qry = @qry +  ' join (select usc.Universal_Sub_Category_Id, qgh.Question_Group_Heading_Id, usch.Sub_Heading_Question_Description '
	SET @qry = @qry +          ' from [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] usch '
	SET @qry = @qry +          ' join [dbo].[UNIVERSAL_SUB_CATEGORIES] usc on usch.Universal_Sub_Category=usc.Universal_Sub_Category '
	SET @qry = @qry +          ' join [dbo].[QUESTION_GROUP_HEADING] qgh on usch.Question_Group_Heading=qgh.Question_Group_Heading) cats '
	SET @qry = @qry +    ' on sca.Question_Group_Heading_Id = cats.Question_Group_Heading_Id and sca.Universal_Sub_Category_Id=cats.Universal_Sub_Category_Id '
    SET @qry = @qry +   ' for XML PATH(''' + @XMLCategory + '''), ELEMENTS'
    SET @qry = N' set @ResultVar = (' + @qry + ')'
	

    SET @XMLString = ''
    SET @ResultVar = ''
	EXECUTE sp_executesql @qry, N'@ResultVar XML OUTPUT', @ResultVar OUTPUT
    SET @XMLString = CONVERT(VARCHAR(MAX), @ResultVar)

	IF LEN(@XMLString) > 0
	  BEGIN
	    SET @strtX = 1
		SET @endX = 1
		SET @prevStrt = 1

	    WHILE @endX < LEN(@XMLString)
		  BEGIN
		    SET @prevStrt = @strtX
		    SET @endTag = 0
            EXEC [dbo].[Parse_XML] @XMLString, @strtX, @endX OUTPUT, @DataStr OUTPUT

			IF (@DataStr = '<' + @XMLCategory + '>') OR (@DataStr = '</' + @XMLCategory + '>')
			  SET @indent = 2
			ELSE
			  SET @indent = 4

            SET @DataStr = SPACE(@indent) + @DataStr
			INSERT #XMLTemp VALUES(@DataStr)

			SET @strtX = @endX
			IF @strtX <= @prevStrt
			  BREAK
		  END
	  END
--select 'SUB_CATEGORY_ANSWERS Complete'

-- Get the Assessment NIST SAL data
	SET @XMLCategory = 'STANDARD_SELECTION'
	SET @qry =       'select ss.Application_Mode, ss.Selected_Sal_Level'
    SET @qry = @qry +     ', (select Sal_Name, Slider_Value, Weight, Display '
	SET @qry = @qry +          'from ' + @dbName + '.[dbo].[GEN_SAL_WEIGHTS] GEN_SAL_WEIGHTS join ' + @dbName + '.[dbo].[GENERAL_SAL] GENERAL_SAL '
	SET @qry = @qry +	         'on GENERAL_SAL.Sal_Weight_Id=GEN_SAL_WEIGHTS.Sal_Weight_Id '
	SET @qry = @qry +         'where GENERAL_SAL.Id=ss.Id for XML AUTO, TYPE, ELEMENTS) '
	SET @qry = @qry +     ', (select Level_Name, Standard_Specific_Sal_Level '
	SET @qry = @qry +          'from ' + @dbName + '.[dbo].[ASSESSMENT_SELECTED_LEVELS] ASSESSMENT_SELECTED_LEVELS '
	SET @qry = @qry +         'where ASSESSMENT_SELECTED_LEVELS.Id=ss.Id for XML AUTO, TYPE, ELEMENTS) '
	SET @qry = @qry +     ', (select Question_Number, Question_Text, Question_Answer '
	SET @qry = @qry +          'from ' + @dbName + '.[dbo].[NIST_SAL_QUESTIONS] NIST_SAL_QUESTIONS '
	SET @qry = @qry + 	      'where NIST_SAL_QUESTIONS.Id=ss.Id for XML AUTO, TYPE, ELEMENTS) '
	SET @qry = @qry +     ', (select Selected, Confidentiality_Value, Confidentiality_Special_Factor, Integrity_Value, Integrity_Special_Factor '
 	SET @qry = @qry +             ', Availability_Value, Availabilty_Special_Factor '
	SET @qry = @qry +          'from ' + @dbName + '.[dbo].[NIST_SAL_INFO_TYPES] NIST_SAL_INFO_TYPES '
	SET @qry = @qry +	      'where NIST_SAL_INFO_TYPES.Id=ss.Id and NIST_SAL_INFO_TYPES.Selected=1 for XML AUTO, TYPE, ELEMENTS) '
    SET @qry = @qry +  'from ' + @dbName + '.[dbo].[STANDARD_SELECTION] ss for XML PATH(''' + @XMLCategory + '''), ELEMENTS'
    SET @qry = N'set @ResultVar = (' + @qry + ')'

    SET @XMLString = ''
    SET @ResultVar = ''
	EXECUTE sp_executesql @qry, N'@ResultVar XML OUTPUT', @ResultVar OUTPUT
    SET @XMLString = CONVERT(VARCHAR(MAX), @ResultVar)

	IF LEN(@XMLString) > 0
	  BEGIN
	    SET @strtX = 1
		SET @endX = 1
		SET @prevStrt = 1

	    WHILE @endX < LEN(@XMLString)
		  BEGIN
		    SET @prevStrt = @strtX
		    SET @endTag = 0
            EXEC [dbo].[Parse_XML] @XMLString, @strtX, @endX OUTPUT, @DataStr OUTPUT

			IF (@DataStr = '<' + @XMLCategory + '>') OR (@DataStr = '</' + @XMLCategory + '>')
			  SET @indent = 2
			ELSE
			  SET @indent = 4

            SET @DataStr = SPACE(@indent) + @DataStr
			INSERT #XMLTemp VALUES(@DataStr)

			SET @strtX = @endX
			IF @strtX <= @prevStrt
			  BREAK
		  END
	  END
--select 'NIST SAL Complete'

-- Get the Assessment CNSS_CIA_JUSTIFICATIONS
	SET @XMLCategory = 'CNSS_CIA_JUSTIFICATIONS'
	SET @qry =       'select CIA_Type, DropDownValue, Justification '
    SET @qry = @qry +  'from ' + @dbName + '.[dbo].[CNSS_CIA_JUSTIFICATIONS] ss for XML PATH(''' + @XMLCategory + '''), ELEMENTS'
    SET @qry = N'set @ResultVar = (' + @qry + ')'

    SET @XMLString = ''
    SET @ResultVar = ''
	EXECUTE sp_executesql @qry, N'@ResultVar XML OUTPUT', @ResultVar OUTPUT
    SET @XMLString = CONVERT(VARCHAR(MAX), @ResultVar)

	IF LEN(@XMLString) > 0
	  BEGIN
	    SET @strtX = 1
		SET @endX = 1
		SET @prevStrt = 1

	    WHILE @endX < LEN(@XMLString)
		  BEGIN
		    SET @prevStrt = @strtX
		    SET @endTag = 0
            EXEC [dbo].[Parse_XML] @XMLString, @strtX, @endX OUTPUT, @DataStr OUTPUT

			IF (@DataStr = '<' + @XMLCategory + '>') OR (@DataStr = '</' + @XMLCategory + '>')
			  SET @indent = 2
			ELSE
			  SET @indent = 4

            SET @DataStr = SPACE(@indent) + @DataStr
			INSERT #XMLTemp VALUES(@DataStr)

			SET @strtX = @endX
			IF @strtX <= @prevStrt
			  BREAK
		  END
	  END
--select 'CNSS_CIA_JUSTIFICATIONS Complete'

-- Get the Assessment FRAMEWORK_TIER_TYPE_ANSWERS
	SET @XMLCategory = 'FRAMEWORK_TIER_TYPE_ANSWERS'
	SET @qry =       'select fd.Tier, fd.TierType, fd.TierQuestion '
    SET @qry = @qry +  'from ' + @dbName + '.[dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ta '
	SET @qry = @qry +  'join ' + @dbName + '.[dbo].[FRAMEWORK_TIER_DEFINITIONS] fd '
	SET @qry = @qry +    'on ta.Tier=fd.Tier and ta.TierType=fd.TierType for XML PATH(''' + @XMLCategory + '''), ELEMENTS'
    SET @qry = N'set @ResultVar = (' + @qry + ')'

    SET @XMLString = ''
    SET @ResultVar = ''
	EXECUTE sp_executesql @qry, N'@ResultVar XML OUTPUT', @ResultVar OUTPUT
    SET @XMLString = CONVERT(VARCHAR(MAX), @ResultVar)

	IF LEN(@XMLString) > 0
	  BEGIN
	    SET @strtX = 1
		SET @endX = 1
		SET @prevStrt = 1

	    WHILE @endX < LEN(@XMLString)
		  BEGIN
		    SET @prevStrt = @strtX
		    SET @endTag = 0
            EXEC [dbo].[Parse_XML] @XMLString, @strtX, @endX OUTPUT, @DataStr OUTPUT

			IF (@DataStr = '<' + @XMLCategory + '>') OR (@DataStr = '</' + @XMLCategory + '>')
			  SET @indent = 2
			ELSE
			  SET @indent = 4

            SET @DataStr = SPACE(@indent) + @DataStr
			INSERT #XMLTemp VALUES(@DataStr)

			SET @strtX = @endX
			IF @strtX <= @prevStrt
			  BREAK
		  END
	  END
--select 'FRAMEWORK_TIER_TYPE_ANSWERS Complete'

	INSERT #XMLTemp VALUES('</ASSESSMENT>')
    
	select id, data from #XMLTemp
		order by id
    DROP TABLE #XMLTemp

END
GO
