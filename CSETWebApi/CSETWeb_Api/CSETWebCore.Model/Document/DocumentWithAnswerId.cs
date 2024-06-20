using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Document
{
    public class DocumentWithAnswerId
    {
        /// <summary>
        /// 
        /// </summary>
        public int Document_Id { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Title { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string FileName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public int Answer_Id { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public int Question_Id { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Question_Title { get; set; }
    }
}
