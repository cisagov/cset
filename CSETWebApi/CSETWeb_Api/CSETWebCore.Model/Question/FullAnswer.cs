//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Model.Question
{
    public class FullAnswer
    {
        /// <summary>
        /// 
        /// </summary>
        public ANSWER a { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public VIEW_QUESTIONS_STATUS b { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public SUB_CATEGORY_ANSWERS sca { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public bool ObservationsExist { get; set; }
    }
}
