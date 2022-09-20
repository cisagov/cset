-- =============================================
-- Author:		Lilly
-- Create date: 3/29/2022
-- Description:	retrieve the median overall
-- =============================================
CREATE PROCEDURE [dbo].[analytics_selectedStandardList]	
@standard_assessment_id int
AS
BEGIN
SELECT  
      Full_Name,
    [SETS].[Set_Name],
     [SETS].[Short_Name]
   
  FROM [dbo].[SETS] 


INNER JOIN AVAILABLE_STANDARDS ON [SETS].[Set_Name]= [AVAILABLE_STANDARDS].[Set_Name] where AVAILABLE_STANDARDS.Assessment_Id=@standard_assessment_id
END
