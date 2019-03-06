using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class IRPResponse
    {
        public List<IRPHeader> headerList;
        public IRPResponse() { headerList = new List<IRPHeader>(); }
    }

    public class IRPHeader
    {
        public string header;
        public List<IRPModel> irpList;

        public IRPHeader() { irpList = new List<IRPModel>(); }
    }

    public class IRPModel
    {
        public int IRP_Id;
        public int Item_Number;
        public string Description;
        public string Risk_1_Description;
        public string Risk_2_Description;
        public string Risk_3_Description;
        public string Risk_4_Description;
        public string Risk_5_Description;
        public string Validation_Approach;
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

    public class IRPSummary {
        public string HeaderText;
        public int[] RiskCount;
        public int RiskSum;
        //public int Risk1Count;
        //public int Risk2Count;
        //public int Risk3Count;
        //public int Risk4Count;
        //public int Risk5Count;
        public int RiskLevel;
        public int RiskLevelId;

        public IRPSummary()
        {
            RiskCount = new int[5];
        }
    }
}
