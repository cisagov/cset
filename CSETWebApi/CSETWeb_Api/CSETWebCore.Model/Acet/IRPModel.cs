//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Acet
{
    public class IRPModel
    {
        public int IRP_Id { get; set; }
        public int Item_Number { get; set; }
        public string Description { get; set; }
        public string DescriptionComment { get; set; }
        public string Validation_Approach { get; set; }
        public string Risk_1_Description { get; set; }
        public string Risk_2_Description { get; set; }
        public string Risk_3_Description { get; set; }
        public string Risk_4_Description { get; set; }
        public string Risk_5_Description { get; set; }
        public int Response { get; set; }
        public string Comment { get; set; }
        public string Risk_Type { get; set; }


        /// <summary>
        /// 
        /// </summary>
        public IRPModel()
        {

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="IRP_Id"></param>
        /// <param name="response"></param>
        /// <param name="comment"></param>
        public IRPModel(int IRP_Id, int response, string comment)
        {
            this.IRP_Id = IRP_Id;
            this.Response = response;
            this.Comment = comment;
        }
    }
}