using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class RelevantEDMAnswersAppendix
    {
        public int Assessment_ID { get; set; }

        public string FuntionName { get; set; }

        public string Summary { get; set; }



        public List<Category> Categories;

    }

    public class Category
    {
        public string Name { get; set; }

        public string Discription { get; set; }


        public List<SubCategory> SubCategories;

    }

    public class SubCategory
    {
        public string Question_Title { get; set; }

        public string Question_Text { get; set; }


        public List<answeredEDM> answeredEDM;

    }

    public class answeredEDM
    {

        public int value { get; set; }

        public string color { get; set; }

        public bool na { get; set; }

    }


}
