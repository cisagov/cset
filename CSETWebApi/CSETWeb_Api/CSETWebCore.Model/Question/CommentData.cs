//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Question
{
    public class CommentData
    {
        public string Comment { get; set; }

        /// <summary>
        /// this is the questions or the document name or 
        /// what ever header identfies this comment
        /// </summary>
        public string AssociatedHeader { get; set; }
        public string Number { get; set; }
        public string Answer { get; set; }
    }
}