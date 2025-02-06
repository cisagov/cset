//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Standards
{
    public class QuestionGroupHeadingSimple
    {
        public string Question_Group_Heading { get; set; }
        public int QGH_Id { get; set; }

        public QuestionGroupHeadingSimple(string name, int id)
        {
            Question_Group_Heading = name;
            QGH_Id = id;
        }
    }
}
