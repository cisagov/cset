//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.Business.Question
{
    public class InformationTabBuilder
    {
        private CSETContext _context;
        private readonly IHtmlFromXamlConverter _converter;
        private ITokenManager _tokenManager;

        public InformationTabBuilder(CSETContext context, IHtmlFromXamlConverter converter, ITokenManager tokenManager)
        {
            _context = context;
            _converter = converter;
            _tokenManager = tokenManager;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="frameworkData"></param>
        /// <returns></returns>
        public List<QuestionInformationTabData> CreateFrameworkInformationTab(FrameworkInfoData frameworkData)
        {
            List<QuestionInformationTabData> tempTabDataList = new List<QuestionInformationTabData>();
            QuestionInformationTabData tab = new QuestionInformationTabData(_converter, _context, _tokenManager);
            tab.BuildFrameworkInfoTab(frameworkData);
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
                QuestionInformationTabData tab = new QuestionInformationTabData(_converter, _context, _tokenManager);
                tab.BuildQuestionTab(questionInfoData, set.Value);
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
                QuestionInformationTabData tab = new QuestionInformationTabData(_converter, _context, _tokenManager);
                tab.BuildRelatedQuestionTab(questionInfoData, set.Value);
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
            QuestionInformationTabData tab = new QuestionInformationTabData(_converter, _context, _tokenManager);
            tab.BuildRequirementInfoTab(reqInfoData, levelManager);
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
            QuestionInformationTabData tab = new QuestionInformationTabData(_converter, _context, _tokenManager);
            tab.BuildComponentInfoTab(questionInfoData);
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
            QuestionInformationTabData tab = new QuestionInformationTabData(_converter, _context, _tokenManager);
            tab.BuildMaturityInfoTab(maturityInfoData);
            tempTabDataList.Add(tab);
            return tempTabDataList;
        }
    }
}