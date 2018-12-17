using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class SetListResponse
    {
        public List<SetDetail> SetList;        
    }

    public class SetDetail
    {
        public string SetName;
        public string FullName;
        public string ShortName;

        public bool Clonable;
        public bool Deletable;

        /// <summary>
        /// Maps to Standard_ToolTip
        /// </summary>
        public string Description;
        public int? SetCategory;

        public bool IsCustom;
        public bool IsDisplayed;

        public List<SetCategory> CategoryList;
    }

    public class SetCategory
    {
        public int Id;
        public string CategoryName;

        public SetCategory(int id, string categoryName)
        {
            this.Id = id;
            this.CategoryName = categoryName;
        }
    }
}
