using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    public class IRPManager
    {
        public IRPResponse GetIRPList(int assessmentId)
        {
            IRPResponse response = new IRPResponse();

            using (var db = new CSET_Context())
            {
                foreach (IRP_HEADER header in db.IRP_HEADER)
                {
                    IRPHeader tempHeader = new IRPHeader()
                    {
                        header = header.Header
                    };

                    foreach (IRP irp in db.IRP)
                    {
                        IRPModel tempIRP = new IRPModel()
                        {
                            IRP_Id = irp.IRP_ID,
                            Item_Number = irp.Item_Number.HasValue ? irp.Item_Number.Value : 0,
                            Description = irp.Description,
                            Risk_1_Description = irp.Risk_1_Description,
                            Risk_2_Description = irp.Risk_2_Description,
                            Risk_3_Description = irp.Risk_3_Description,
                            Risk_4_Description = irp.Risk_4_Description,
                            Risk_5_Description = irp.Risk_5_Description,
                            Validation_Approach = irp.Validation_Approach
                        };

                        Assessment_IRP answer = db.Assessment_IRP.FirstOrDefault(i => i.IRP_.IRP_ID == irp.IRP_ID &&
                            i.Assessment_.Assessment_Id == assessmentId);
                        if (answer == null)
                        {
                            answer = new Assessment_IRP()
                            {
                                Response = 0,
                                Comment = ""
                            };
                            answer.IRP_ = db.IRP.FirstOrDefault(i => i.IRP_ID == irp.IRP_ID);
                            answer.Assessment_ = db.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
                            db.Assessment_IRP.Add(answer);
                        }
                        tempIRP.Response = answer.Response.Value;
                        tempIRP.Comment = answer.Comment;
                        tempHeader.irpList.Add(tempIRP);
                    }

                    response.headerList.Add(tempHeader);
                }
                db.SaveChanges();
            }

            return response;
        }

        public void PersistSelectedIRP(int assessmentId, IRPModel irp)
        {
            if (assessmentId == 0) { return; }
            if (irp == null) { return; }

            using (var db = new CSET_Context())
            {
                Assessment_IRP answer = db.Assessment_IRP.FirstOrDefault(i => i.IRP_Id == irp.IRP_Id &&
                    i.Assessment_.Assessment_Id == assessmentId);
                if (answer != null)
                {
                    answer.Response = irp.Response;
                    answer.Comment = irp.Comment;
                }
                else
                {
                    answer = new Assessment_IRP()
                    {
                        Response = irp.Response,
                        Comment = irp.Comment,
                    };
                    answer.Assessment_ = db.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
                    db.Assessment_IRP.Add(answer);
                }
                db.SaveChanges();
            }
        }
    }
}
