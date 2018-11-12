//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data.ControlData;
using System.Collections.Generic;
using DataLayer;

namespace CSET_Main.Questions.InformationTabData
{
    public class InformationTabBuilder
    {
        public CSETWebEntities DataContext { get; }

        public InformationTabBuilder(CSETWebEntities context)
        {
            this.DataContext = context;
        }

        internal List<QuestionInformationTabData> CreateFrameworkInformationTab( FrameworkInfoData frameworkData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData();
            tab.BuildFrameworkInfoTab(frameworkData,DataContext);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }

        internal List<QuestionInformationTabData> CreateQuestionInformationTab(QuestionInfoData questionInfoData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            foreach (var set in questionInfoData.Sets)
            {
                QuestionInformationTabData tab = new QuestionInformationTabData();
                tab.BuildQuestionTab(questionInfoData, set.Value,DataContext);                
                tempTabDataList.Add(tab);
            }
            return tempTabDataList;
        }
        internal List<QuestionInformationTabData> CreateRelatedQuestionInformationTab(RelatedQuestionInfoData questionInfoData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            foreach (var set in questionInfoData.Sets)
            {
                QuestionInformationTabData tab = new QuestionInformationTabData();
                tab.BuildRelatedQuestionTab(questionInfoData, set.Value, DataContext);
                tempTabDataList.Add(tab);
            }
            return tempTabDataList;
        }

        internal List<QuestionInformationTabData> CreateRequirementInformationTab(RequirementInfoData reqInfoData,IStandardSpecficLevelRepository levelManager)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData();
            tab.BuildRequirementInfoTab(reqInfoData,levelManager,DataContext);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }

        internal List<QuestionInformationTabData> CreateComponentInformationTab(ComponentQuestionInfoData questionInfoData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData();
            tab.BuildComponentInfoTab(questionInfoData, DataContext);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }       
    }
}


