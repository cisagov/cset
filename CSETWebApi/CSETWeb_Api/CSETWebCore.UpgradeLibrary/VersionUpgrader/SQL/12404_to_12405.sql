/*
    Remove unused stored procedures from the database.
    These procedures are no longer referenced in the C# codebase.
*/

-- Acet_GetActionItemsForReport
IF OBJECT_ID('dbo.Acet_GetActionItemsForReport', 'P') IS NOT NULL
    DROP PROCEDURE dbo.Acet_GetActionItemsForReport;
GO

-- AcetAnswerDistribution
IF OBJECT_ID('dbo.AcetAnswerDistribution', 'P') IS NOT NULL
    DROP PROCEDURE dbo.AcetAnswerDistribution;
GO

-- CheckHeading (replaced with LINQ equivalent in CsetwebContextExtensions.cs)
IF OBJECT_ID('dbo.CheckHeading', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CheckHeading;
GO

-- DeleteAssessment
IF OBJECT_ID('dbo.DeleteAssessment', 'P') IS NOT NULL
    DROP PROCEDURE dbo.DeleteAssessment;
GO

-- DeleteUser
IF OBJECT_ID('dbo.DeleteUser', 'P') IS NOT NULL
    DROP PROCEDURE dbo.DeleteUser;
GO

-- Get_Recommendations
IF OBJECT_ID('dbo.Get_Recommendations', 'P') IS NOT NULL
    DROP PROCEDURE dbo.Get_Recommendations;
GO

-- GetAnswerDistribGroupings
IF OBJECT_ID('dbo.GetAnswerDistribGroupings', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetAnswerDistribGroupings;
GO

-- GetAnswerDistribMaturity
IF OBJECT_ID('dbo.GetAnswerDistribMaturity', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetAnswerDistribMaturity;
GO

-- GetAreasData
IF OBJECT_ID('dbo.GetAreasData', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetAreasData;
GO

-- GetAreasOverall
IF OBJECT_ID('dbo.GetAreasOverall', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetAreasOverall;
GO

-- GetComparisonAreasFile
IF OBJECT_ID('dbo.GetComparisonAreasFile', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetComparisonAreasFile;
GO

-- GetComparisonFileOveralls
IF OBJECT_ID('dbo.GetComparisonFileOveralls', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetComparisonFileOveralls;
GO

-- GetComparisonFilePercentage
IF OBJECT_ID('dbo.GetComparisonFilePercentage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetComparisonFilePercentage;
GO

-- GetComparisonFileSummary
IF OBJECT_ID('dbo.GetComparisonFileSummary', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetComparisonFileSummary;
GO

-- GetCompatibilityCounts
IF OBJECT_ID('dbo.GetCompatibilityCounts', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetCompatibilityCounts;
GO

-- GetMaturityComparisonBestToWorst
IF OBJECT_ID('dbo.GetMaturityComparisonBestToWorst', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetMaturityComparisonBestToWorst;
GO

-- GetMaturityGroupings
IF OBJECT_ID('dbo.GetMaturityGroupings', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetMaturityGroupings;
GO

-- GetPercentageOverall
IF OBJECT_ID('dbo.GetPercentageOverall', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetPercentageOverall;
GO

-- IseAnswerDistribution
IF OBJECT_ID('dbo.IseAnswerDistribution', 'P') IS NOT NULL
    DROP PROCEDURE dbo.IseAnswerDistribution;
GO

-- usp_AggregationCustomQuestionnaireLoad
IF OBJECT_ID('dbo.usp_AggregationCustomQuestionnaireLoad', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_AggregationCustomQuestionnaireLoad;
GO

-- usp_Assessments_Completion_For_Access_Key
IF OBJECT_ID('dbo.usp_Assessments_Completion_For_Access_Key', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Assessments_Completion_For_Access_Key;
GO

-- usp_Assessments_Completion_For_User
IF OBJECT_ID('dbo.usp_Assessments_Completion_For_User', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Assessments_Completion_For_User;
GO

-- usp_CF_ConvertLegacyFull
IF OBJECT_ID('dbo.usp_CF_ConvertLegacyFull', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CF_ConvertLegacyFull;
GO

-- usp_CF_Questions
IF OBJECT_ID('dbo.usp_CF_Questions', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CF_Questions;
GO

-- usp_CF_Score_Averages
IF OBJECT_ID('dbo.usp_CF_Score_Averages', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CF_Score_Averages;
GO

-- usp_CF_Score_Overall
IF OBJECT_ID('dbo.usp_CF_Score_Overall', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CF_Score_Overall;
GO

-- usp_CyOTEQuestionsAnswers
IF OBJECT_ID('dbo.usp_CyOTEQuestionsAnswers', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CyOTEQuestionsAnswers;
GO

-- usp_financial_attributes
IF OBJECT_ID('dbo.usp_financial_attributes', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_financial_attributes;
GO

-- usp_GenerateSPRSScore
IF OBJECT_ID('dbo.usp_GenerateSPRSScore', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GenerateSPRSScore;
GO

-- usp_GetAssessmentPie
IF OBJECT_ID('dbo.usp_GetAssessmentPie', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetAssessmentPie;
GO

-- usp_GetComponentsRankedCategoriesPage
IF OBJECT_ID('dbo.usp_GetComponentsRankedCategoriesPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetComponentsRankedCategoriesPage;
GO

-- usp_GetComponentsResultsByCategoryPage
IF OBJECT_ID('dbo.usp_GetComponentsResultsByCategoryPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetComponentsResultsByCategoryPage;
GO

-- usp_GetComponentsSummaryPage
IF OBJECT_ID('dbo.usp_GetComponentsSummaryPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetComponentsSummaryPage;
GO

-- usp_GetComponentTypesPage
IF OBJECT_ID('dbo.usp_GetComponentTypesPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetComponentTypesPage;
GO

-- usp_getCSETQuestionsForCRRM
IF OBJECT_ID('dbo.usp_getCSETQuestionsForCRRM', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getCSETQuestionsForCRRM;
GO

-- usp_getFinancialQuestions
IF OBJECT_ID('dbo.usp_getFinancialQuestions', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getFinancialQuestions;
GO

-- usp_getGenericModelSummaryByGoal
IF OBJECT_ID('dbo.usp_getGenericModelSummaryByGoal', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getGenericModelSummaryByGoal;
GO

-- usp_getMaturitySummaryOverall
IF OBJECT_ID('dbo.usp_getMaturitySummaryOverall', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getMaturitySummaryOverall;
GO

-- usp_getMedianOverall
IF OBJECT_ID('dbo.usp_getMedianOverall', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getMedianOverall;
GO

-- usp_getMinMaxAverageForSectorIndustry
IF OBJECT_ID('dbo.usp_getMinMaxAverageForSectorIndustry', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getMinMaxAverageForSectorIndustry;
GO

-- usp_getRankedStandardCategories
IF OBJECT_ID('dbo.usp_getRankedStandardCategories', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getRankedStandardCategories;
GO

-- usp_getRRASummaryPage
IF OBJECT_ID('dbo.usp_getRRASummaryPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getRRASummaryPage;
GO

-- usp_GetStandardsRankedCategoriesPage
IF OBJECT_ID('dbo.usp_GetStandardsRankedCategoriesPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetStandardsRankedCategoriesPage;
GO

-- usp_GetStandardsResultsByCategoryPage
IF OBJECT_ID('dbo.usp_GetStandardsResultsByCategoryPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetStandardsResultsByCategoryPage;
GO

-- usp_getVADRSummaryPage
IF OBJECT_ID('dbo.usp_getVADRSummaryPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getVADRSummaryPage;
GO

-- update_demographic_sectors
IF OBJECT_ID('dbo.update_demographic_sectors', 'P') IS NOT NULL
    DROP PROCEDURE dbo.update_demographic_sectors;
GO

-- usp_GetQuestionsWithFeedBack
IF OBJECT_ID('dbo.usp_GetQuestionsWithFeedBack', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetQuestionsWithFeedBack;
GO

-- usp_GetRawCountsForEachAssessment_Standards
IF OBJECT_ID('dbo.usp_GetRawCountsForEachAssessment_Standards', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetRawCountsForEachAssessment_Standards;
GO

-- usp_MaturityDetailsCalculations
IF OBJECT_ID('dbo.usp_MaturityDetailsCalculations', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_MaturityDetailsCalculations;
GO

-- usp_StatementsReviewed
IF OBJECT_ID('dbo.usp_StatementsReviewed', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_StatementsReviewed;
GO

-- usp_StatementsReviewedTabTotals
IF OBJECT_ID('dbo.usp_StatementsReviewedTabTotals', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_StatementsReviewedTabTotals;
GO

-- Get_Assess_Detail_Filter_Data
IF OBJECT_ID('dbo.Get_Assess_Detail_Filter_Data', 'P') IS NOT NULL
    DROP PROCEDURE dbo.Get_Assess_Detail_Filter_Data;
GO

-- Get_Merge_Conflicts
IF OBJECT_ID('dbo.Get_Merge_Conflicts', 'P') IS NOT NULL
    DROP PROCEDURE dbo.Get_Merge_Conflicts;
GO

-- GetMaturityDetailsCalculations
IF OBJECT_ID('dbo.GetMaturityDetailsCalculations', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetMaturityDetailsCalculations;
GO

-- clean_out_requirements_mode
IF OBJECT_ID('dbo.clean_out_requirements_mode', 'P') IS NOT NULL
    DROP PROCEDURE dbo.clean_out_requirements_mode;
GO

-- usp_CopyIntoSet_Delete (replaced with LINQ equivalent in ModuleBuilderBusiness.cs)
IF OBJECT_ID('dbo.usp_CopyIntoSet_Delete', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CopyIntoSet_Delete;
GO

-- usp_getFirstPage (replaced with LINQ equivalent in CsetwebContextExtensions.cs)
IF OBJECT_ID('dbo.usp_getFirstPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getFirstPage;
GO

-- usp_getVADRSummaryOverall (replaced with LINQ equivalent in VADRReports.cs)
IF OBJECT_ID('dbo.usp_getVADRSummaryOverall', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getVADRSummaryOverall;
GO

-- usp_countsForLevelsByGroupMaturityModel (replaced with LINQ equivalent in MaturityBusiness.cs)
IF OBJECT_ID('dbo.usp_countsForLevelsByGroupMaturityModel', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_countsForLevelsByGroupMaturityModel;
GO

-- usp_getVADRSummaryByGoalOverall (replaced with LINQ equivalent in VADRReports.cs)
IF OBJECT_ID('dbo.usp_getVADRSummaryByGoalOverall', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getVADRSummaryByGoalOverall;
GO

-- usp_getVADRSummaryByGoal (replaced with LINQ equivalent in VADRReports.cs)
IF OBJECT_ID('dbo.usp_getVADRSummaryByGoal', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getVADRSummaryByGoal;
GO

-- usp_GetStandardsSummaryPage (replaced with LINQ equivalent in StandardsSummaryBusiness.cs)
IF OBJECT_ID('dbo.usp_GetStandardsSummaryPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetStandardsSummaryPage;
GO

-- usp_getStandardsSummary (replaced with LINQ equivalent in StandardsSummaryBusiness.cs)
IF OBJECT_ID('dbo.usp_getStandardsSummary', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getStandardsSummary;
GO

-- usp_GetRankedCategoriesPage (replaced with LINQ equivalent in RankedCategoriesBusiness.cs)
IF OBJECT_ID('dbo.usp_GetRankedCategoriesPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetRankedCategoriesPage;
GO

-- usp_getRankedCategories (replaced with LINQ equivalent in RankedCategoriesBusiness.cs)
IF OBJECT_ID('dbo.usp_getRankedCategories', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getRankedCategories;
GO

-- usp_GetOverallRankedCategoriesPage (replaced with LINQ equivalent in RankedCategoriesBusiness.cs)
IF OBJECT_ID('dbo.usp_GetOverallRankedCategoriesPage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetOverallRankedCategoriesPage;
GO

-- usp_getOverallRankedCategories (replaced with LINQ equivalent in RankedCategoriesBusiness.cs)
IF OBJECT_ID('dbo.usp_getOverallRankedCategories', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getOverallRankedCategories;
GO

-- usp_getComponentTypes (replaced with LINQ equivalent in ComponentTypesBusiness.cs)
IF OBJECT_ID('dbo.usp_getComponentTypes', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getComponentTypes;
GO

-- usp_getComponentsSummary (replaced with LINQ equivalent in ComponentsSummaryBusiness.cs)
IF OBJECT_ID('dbo.usp_getComponentsSummary', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getComponentsSummary;
GO

-- usp_getStandardsResultsByCategory (replaced with LINQ equivalent in StandardsResultsByCategoryBusiness.cs)
IF OBJECT_ID('dbo.usp_getStandardsResultsByCategory', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getStandardsResultsByCategory;
GO

-- usp_getStandardsRankedCategories (replaced with LINQ equivalent in StandardsRankedCategoriesBusiness.cs)
IF OBJECT_ID('dbo.usp_getStandardsRankedCategories', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getStandardsRankedCategories;
GO

-- usp_getStandardSummaryOverall (replaced with LINQ equivalent in StandardSummaryOverallBusiness.cs)
IF OBJECT_ID('dbo.usp_getStandardSummaryOverall', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getStandardSummaryOverall;
GO

-- usp_getRRASummaryOverall (replaced with LINQ equivalent in RraSummary.cs)
IF OBJECT_ID('dbo.usp_getRRASummaryOverall', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getRRASummaryOverall;
GO

-- usp_getRRASummaryByGoalOverall (replaced with LINQ equivalent in RraSummary.cs)
IF OBJECT_ID('dbo.usp_getRRASummaryByGoalOverall', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getRRASummaryByGoalOverall;
GO

-- usp_getRRASummaryByGoal (replaced with LINQ equivalent in RraSummary.cs)
IF OBJECT_ID('dbo.usp_getRRASummaryByGoal', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getRRASummaryByGoal;
GO

-- usp_getRRASummary (replaced with LINQ equivalent in RraSummary.cs)
IF OBJECT_ID('dbo.usp_getRRASummary', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getRRASummary;
GO

-- usp_GetMaturityAnswerTotals (replaced with LINQ equivalent in MaturityAnswerTotalsBusiness.cs)
IF OBJECT_ID('dbo.usp_GetMaturityAnswerTotals', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetMaturityAnswerTotals;
GO

-- usp_getComponentsResultsByCategory (replaced with LINQ equivalent in ComponentsResultsByCategoryBusiness.cs)
IF OBJECT_ID('dbo.usp_getComponentsResultsByCategory', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getComponentsResultsByCategory;
GO

-- usp_getAnswerComponentOverrides (replaced with LINQ query using Answer_Components_Overrides view)
IF OBJECT_ID('dbo.usp_getAnswerComponentOverrides', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getAnswerComponentOverrides;
GO

-- usp_Answer_Components_Default (replaced with LINQ query using Answer_Components_Default view)
IF OBJECT_ID('dbo.usp_Answer_Components_Default', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Answer_Components_Default;
GO

-- usp_CopyIntoSet (replaced with LINQ equivalent in ModuleBuilderBusiness.cs)
IF OBJECT_ID('dbo.usp_CopyIntoSet', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CopyIntoSet;
GO

-- usp_getComponentsRankedCategories (replaced with LINQ equivalent in ComponentsRankedCategoriesBusiness.cs)
IF OBJECT_ID('dbo.usp_getComponentsRankedCategories', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getComponentsRankedCategories;
GO

-- usp_getExplodedComponent (replaced with LINQ query using Answer_Components_Exploded view)
IF OBJECT_ID('dbo.usp_getExplodedComponent', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getExplodedComponent;
GO

-- usp_getVADRSummary (replaced with LINQ equivalent in VADRReports.cs)
IF OBJECT_ID('dbo.usp_getVADRSummary', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_getVADRSummary;
GO

-- GetCombinedOveralls (replaced with LINQ equivalent in CsetContextExtensions.GetCombinedOveralls.cs)
IF OBJECT_ID('dbo.GetCombinedOveralls', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetCombinedOveralls;
GO
