//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessManagers.Analysis;
using CSETWeb_Api.Helpers;
using DataLayerCore.Manual;
using DataLayerCore.Model;
using Snickler.EFCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Http;
using CSETWeb_Api.BusinessLogic.Models;
using Microsoft.EntityFrameworkCore;

namespace CSETWeb_Api.Controllers
{
    //[CSETAuthorize]
    public class AggregationAnalysisController : ApiController
    {
        [HttpPost]
        [Route("api/aggregation/analysis/categorypercentcompare")]
        public HorizBarChart CategoryPercentCompare([FromUri] int aggregationId)
        {
            var response = new HorizBarChart();
            response.reportType = "Trend Category Percent Comparisons";


            DataTable dt = new DataTable();
            dt.Columns.Add("AssessmentId", typeof(int));
            dt.Columns.Add("Alias");



            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    var row = dt.NewRow();
                    row["AssessmentId"] = a.Assessment_Id;
                    row["Alias"] = a.Alias;
                    dt.Rows.Add(row);

                    var rrr = GetCategoryPercentages(a.Assessment_Id, db);

                    foreach (usp_getStandardsResultsByCategory r in rrr)
                    {
                        if (!dt.Columns.Contains(r.Question_Group_Heading))
                        {
                            dt.Columns.Add(r.Question_Group_Heading, typeof(float));
                        }

                        row[r.Question_Group_Heading] = r.prc;
                    }

                }

                // build the response
                List<string> categories = dt.Columns.Cast<DataColumn>()
                       .OrderBy(x => x.ColumnName)
                       .Select(x => x.ColumnName)
                       .ToList();

                categories.Remove("AssessmentId");
                categories.Remove("Alias");


                foreach (string category in categories)
                {
                    response.categories.Add(category);
                }

                foreach (DataRow rowAssessment in dt.Rows)
                {
                    var ds = new BusinessLogic.Models.DataSet();
                    response.datasets.Add(ds);
                    ds.label = rowAssessment["Alias"].ToString();

                    foreach (string category in categories)
                    {
                        ds.data.Add(rowAssessment[category] != DBNull.Value ? (float)rowAssessment[category] : 0f);
                    }
                }
            }

            return response;
        }



        /// <summary>
        /// Returns the category percentages for an assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="db"></param>
        private List<usp_getStandardsResultsByCategory> GetCategoryPercentages(int assessmentId, CSET_Context db)
        {
            List<usp_getStandardsResultsByCategory> response = null;

            db.LoadStoredProc("[dbo].[usp_getStandardsResultsByCategory]")
                        .WithSqlParam("assessment_Id", assessmentId)
                        .ExecuteStoredProc((handler) =>
                        {
                            var result = handler.ReadToList<usp_getStandardsResultsByCategory>();
                            var labels = (from usp_getStandardsResultsByCategory an in result
                                          orderby an.Question_Group_Heading
                                          select an.Question_Group_Heading).Distinct().ToList();


                            response = (List<usp_getStandardsResultsByCategory>)result;
                        });

            return response;
        }
    }
}
