//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data.ControlData;
using System.Collections.Generic;
using CSETWebCore.DataLayer;

namespace CSET_Main.Questions.InformationTabData
{
    public class InformationTabBuilder
    {
        public CSET_Context DataContext { get; }

        public InformationTabBuilder(CSET_Context context)
        {
            this.DataContext = context;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="frameworkData"></param>
        /// <returns></returns>
        internal List<QuestionInformationTabData> CreateFrameworkInformationTab( FrameworkInfoData frameworkData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData();
            tab.BuildFrameworkInfoTab(frameworkData,DataContext);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionInfoData"></param>
        /// <returns></returns>
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


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionInfoData"></param>
        /// <returns></returns>
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


        /// <summary>
        /// 
        /// </summary>
        /// <param name="reqInfoData"></param>
        /// <param name="levelManager"></param>
        /// <returns></returns>
        internal List<QuestionInformationTabData> CreateRequirementInformationTab(RequirementInfoData reqInfoData,IStandardSpecficLevelRepository levelManager)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData();
            tab.BuildRequirementInfoTab(reqInfoData,levelManager,DataContext);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionInfoData"></param>
        /// <returns></returns>
        internal List<QuestionInformationTabData> CreateComponentInformationTab(ComponentQuestionInfoData questionInfoData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData();
            tab.BuildComponentInfoTab(questionInfoData, DataContext);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }       


        /// <summary>
        /// 
        /// </summary>
        /// <param name="maturityInfoData"></param>
        /// <returns></returns>
        internal List<QuestionInformationTabData> CreateMaturityInformationTab(MaturityQuestionInfoData maturityInfoData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData();
            tab.BuildMaturityInfoTab(maturityInfoData, DataContext);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }
    }
}


