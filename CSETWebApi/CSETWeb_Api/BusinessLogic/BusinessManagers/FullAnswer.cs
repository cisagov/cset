//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;

namespace CSETWeb_Api.BusinessManagers
{
    internal class FullAnswer
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
        public bool FindingsExist { get; set; }
    }
}

