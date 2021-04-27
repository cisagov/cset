namespace CSETWebCore.Model.Acet
{
    public class IRPModel
    {
        public int IRP_Id;
        public int Item_Number;
        public string Description;
        public string DescriptionComment;
        public string Validation_Approach;
        public string Risk_1_Description;
        public string Risk_2_Description;
        public string Risk_3_Description;
        public string Risk_4_Description;
        public string Risk_5_Description;
        public int Response;
        public string Comment;

        public IRPModel()
        {

        }
        public IRPModel(int IRP_Id, int response, string comment)
        {
            this.IRP_Id = IRP_Id;
            this.Response = response;
            this.Comment = comment;
        }
    }
}