using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using Snickler.EFCore;

namespace CSETWebCore.Business.Reports;

public class VbosSummary
{
    private readonly CSETContext _context;


    /// <summary>
    /// modeled from RRA
    /// </summary>
    /// <param name="context"></param>
    public VbosSummary(CSETContext context)
    {
        this._context = context;
    }

    public List<VbosStoredProcModels.usp_getVbosSummaryOverall> GetVbosSummaryOverall(int assessmentId)
    {
        List<VbosStoredProcModels.usp_getVbosSummaryOverall> results = null;

        _context.LoadStoredProc("[usp_getVBOSSummaryOverall]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                results = handler.ReadToList<VbosStoredProcModels.usp_getVbosSummaryOverall>().ToList();
            });
        return results;

    }
}