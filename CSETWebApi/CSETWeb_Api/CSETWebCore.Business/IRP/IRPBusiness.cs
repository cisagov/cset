using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.IRP;
using CSETWebCore.Model.Acet;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Business.IRP
{
    public class IRPBusiness : IIRPBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;

        public IRPBusiness(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
        }
        public async Task<IRPResponse> GetIRPList(int assessmentId)
        {
            IRPResponse response = new IRPResponse();
            var headerList = await _context.IRP_HEADER.ToListAsync();
            foreach (IRP_HEADER header in headerList)
            {
                IRPHeader tempHeader = new IRPHeader()
                {
                    header = header.Header
                };
                var irpList = await _context.IRP.Where(x => x.Header_Id == header.IRP_Header_Id).ToListAsync();
                foreach (DataLayer.Model.IRP irp in irpList)
                {
                    IRPModel tempIRP = new IRPModel()
                    {
                        IRP_Id = irp.IRP_ID,
                        Item_Number = irp.Item_Number ?? 0,
                        Description = irp.Description,
                        DescriptionComment = irp.DescriptionComment,
                        Risk_1_Description = irp.Risk_1_Description,
                        Risk_2_Description = irp.Risk_2_Description,
                        Risk_3_Description = irp.Risk_3_Description,
                        Risk_4_Description = irp.Risk_4_Description,
                        Risk_5_Description = irp.Risk_5_Description,
                        Validation_Approach = irp.Validation_Approach
                    };

                    // Get the existing answer or create a blank 
                    ASSESSMENT_IRP answer = await _context.ASSESSMENT_IRP.FirstOrDefaultAsync(ans =>
                        ans.IRP_Id == irp.IRP_ID &&
                        ans.Assessment.Assessment_Id == assessmentId);
                    if (answer == null)
                    {
                        answer = new ASSESSMENT_IRP()
                        {
                            Assessment_Id = assessmentId,
                            IRP_Id = irp.IRP_ID,
                            Response = 0,
                            Comment = ""
                        };

                        await _context.ASSESSMENT_IRP.AddAsync(answer);
                    }
                    tempIRP.Response = answer.Response.Value;
                    tempIRP.Comment = answer.Comment;
                    tempHeader.irpList.Add(tempIRP);
                }

                response.headerList.Add(tempHeader);
            }
            if (await _context.SaveChangesAsync() > 0)
            {
                await _assessmentUtil.TouchAssessment(assessmentId);
            }


            return response;
        }

        public async Task PersistSelectedIRP(int assessmentId, IRPModel irp)
        {
            if (assessmentId == 0) { return; }
            if (irp == null) { return; }


            ASSESSMENT_IRP answer = await _context.ASSESSMENT_IRP.FirstOrDefaultAsync(i => i.IRP_Id == irp.IRP_Id &&
                i.Assessment.Assessment_Id == assessmentId);
            if (answer != null)
            {
                answer.Response = irp.Response;
                answer.Comment = irp.Comment;
            }
            else
            {
                answer = new ASSESSMENT_IRP()
                {
                    Response = irp.Response,
                    Comment = irp.Comment,
                };
                answer.Assessment = await _context.ASSESSMENTS.FirstOrDefaultAsync(a => a.Assessment_Id == assessmentId);
                await _context.ASSESSMENT_IRP.AddAsync(answer);
            }
            if (await _context.SaveChangesAsync() > 0)
            {
                await _assessmentUtil.TouchAssessment(assessmentId);
            }
        }
    }
}