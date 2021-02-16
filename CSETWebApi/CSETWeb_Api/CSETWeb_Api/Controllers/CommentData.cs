//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWeb_Api.Controllers
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