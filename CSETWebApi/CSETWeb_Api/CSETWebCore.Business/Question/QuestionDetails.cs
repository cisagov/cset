//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Observations;
using System.Collections.Generic;


namespace CSETWebCore.Business.Question
{
    /// <summary>
    /// Before converting to .NET 5, this was known as QuestionDetailsContentViewModel.
    /// </summary>
    public class QuestionDetails
    {
        public int AssessmentId { get; set; }

        public int QuestionId { get; set; }

        public int SelectedStandardTabIndex { get; set; }


        public string NoQuestionInformationText { get; set; }


        public bool ShowQuestionDetailTab { get; set; }


        private bool isDetailAndInfo { get; set; }


        public bool IsNoQuestion { get; set; }


        private int selectedTabIndex { get; set; }


        public bool IsDetailAndInfo { get; set; }


        /// <summary>
        /// 
        /// </summary>
        public List<QuestionInformationTabData> ListTabs { get; set; }


        public int SelectedTabIndex { get; set; }


        /// <summary>
        /// List contains only the title, finding_id and answer id
        /// call observation details for complete observation information
        /// </summary>
        public List<Observation> Observations { get; set; }


        /// <summary>
        /// A list of documents attached to the answer.
        /// </summary>
        public List<CSETWebCore.Model.Document.Document> Documents { get; set; }


        public bool Is_Component { get; set; }


        public Dictionary<int, COMPONENT_SYMBOLS> SymbolInfo { get; set; }
    }
}