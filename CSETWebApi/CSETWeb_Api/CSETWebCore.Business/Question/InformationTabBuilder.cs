using System.Collections.Generic;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Question;
using CSETWebCore.DataLayer;

namespace CSETWebCore.Business.Question
{
    public class InformationTabBuilder
    {
        private CSETContext _context;
        private readonly IHtmlFromXamlConverter _converter;

        public InformationTabBuilder(CSETContext context, IHtmlFromXamlConverter converter)
        {
            _context = context;
            _converter = converter;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="frameworkData"></param>
        /// <returns></returns>
        public List<QuestionInformationTabData> CreateFrameworkInformationTab(FrameworkInfoData frameworkData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData(_converter);
            tab.BuildFrameworkInfoTab(frameworkData, _context);
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
                QuestionInformationTabData tab = new QuestionInformationTabData(_converter);
                tab.BuildQuestionTab(questionInfoData, set.Value, _context);
                tempTabDataList.Add(tab);
            }
            return tempTabDataList;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionInfoData"></param>
        /// <returns></returns>
        public List<QuestionInformationTabData> CreateRelatedQuestionInformationTab(RelatedQuestionInfoData questionInfoData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            foreach (var set in questionInfoData.Sets)
            {
                QuestionInformationTabData tab = new QuestionInformationTabData(_converter);
                tab.BuildRelatedQuestionTab(questionInfoData, set.Value, _context);
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
        public List<QuestionInformationTabData> CreateRequirementInformationTab(RequirementInfoData reqInfoData, IStandardSpecficLevelRepository levelManager)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData(_converter);
            tab.BuildRequirementInfoTab(reqInfoData, levelManager, _context);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionInfoData"></param>
        /// <returns></returns>
        public List<QuestionInformationTabData> CreateComponentInformationTab(ComponentQuestionInfoData questionInfoData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData(_converter);
            tab.BuildComponentInfoTab(questionInfoData, _context);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="maturityInfoData"></param>
        /// <returns></returns>
        public List<QuestionInformationTabData> CreateMaturityInformationTab(MaturityQuestionInfoData maturityInfoData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData(_converter);
            tab.BuildMaturityInfoTab(maturityInfoData, _context);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }
    }
}