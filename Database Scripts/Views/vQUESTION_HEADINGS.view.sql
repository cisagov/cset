
CREATE VIEW [dbo].[vQUESTION_HEADINGS]
AS
SELECT dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Heading_Pair_Id, dbo.QUESTION_GROUP_HEADING.Question_Group_Heading, dbo.QUESTION_GROUP_HEADING.Question_Group_Heading_Id, 
                  dbo.UNIVERSAL_SUB_CATEGORIES.Universal_Sub_Category, dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Sub_Heading_Question_Description, dbo.UNIVERSAL_SUB_CATEGORIES.Universal_Sub_Category_Id
FROM     dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS INNER JOIN
                  dbo.UNIVERSAL_SUB_CATEGORIES ON dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Universal_Sub_Category_Id = dbo.UNIVERSAL_SUB_CATEGORIES.Universal_Sub_Category_Id INNER JOIN
                  dbo.QUESTION_GROUP_HEADING ON dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Question_Group_Heading_Id = dbo.QUESTION_GROUP_HEADING.Question_Group_Heading_Id
