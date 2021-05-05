//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;
using CSETWebCore.DataLayer;
using Hangfire;
using Hangfire.Common;
using Hangfire.Console;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json;

namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class SetsController : ApiController
    {
        public SetsController() : base()
        {
        }

        [HttpGet]
        [Route("api/sets")]
        public Task<HttpResponseMessage> GetAllSets()
        {
            using (var db = new CSET_Context())
            {
                var sets = db.SETS.Where(s => s.Is_Displayed ?? true)
                    .Select(s => new { Name = s.Full_Name, SetName = s.Set_Name })
                    .OrderBy(s => s.Name)
                    .ToArray();
                return Task.FromResult(Request.CreateResponse(sets));
            }
        }

        [Route("api/sets/import/status/{id}")]
        [HttpGet]
        public Task<HttpResponseMessage> GetImportStatus([FromUri] string id)
        {
            var state = Hangfire.States.AwaitingState.StateName;
            var messages = Enumerable.Empty<string>();
            try
            {
                var job = JobStorage.Current.GetMonitoringApi().JobDetails(id);
                if (job != null)
                {
                    var history = job.History.OrderByDescending(s => s.CreatedAt);
                    state = (
                        history.FirstOrDefault(s => s.StateName == Hangfire.States.SucceededState.StateName) ??
                        history.FirstOrDefault(s => s.StateName == Hangfire.States.FailedState.StateName) ??
                        history.FirstOrDefault(s => s.StateName == Hangfire.States.ProcessingState.StateName)
                    )?.StateName ?? state;


                    var processingRecord = history.FirstOrDefault(s => s.StateName == Hangfire.States.ProcessingState.StateName);
                    if (processingRecord != null)
                    {
                        var timestamp = JobHelper.DeserializeDateTime(processingRecord.Data["StartedAt"]);
                        messages = JobStorage.Current.GetConsoleApi().GetLines(id, timestamp, Hangfire.Console.Monitoring.LineType.Text).OfType<Hangfire.Console.Monitoring.TextLineDto>().Select(s => s.Text);
                    }
                }
            }
            catch { }

            return Task.FromResult(Request.CreateResponse(new { state, errors = messages }));
        }

        /// <summary>
        /// Import new standards into CSET
        /// </summary>
        [HttpPost]
        [Route("api/sets/import")]
        public Task<HttpResponseMessage> Import([FromBody] ExternalStandard externalStandard)
        {
            CsetLogManager.Instance.LogInfoMessage("SetsController.Import() - \n{0}", JsonConvert.SerializeObject(externalStandard));

            var response = default(HttpResponseMessage);
            try
            {
                if (ModelState.IsValid)
                {
                    var id = BackgroundJob.Enqueue(() => HangfireExecutor.SaveImport(externalStandard, null));
                    response = Request.CreateResponse(new { id });
                }
                else
                {
                    response = Request.CreateErrorResponse(HttpStatusCode.BadRequest, ModelState);
                }
            }
            catch (Exception ex)
            {
                response = Request.CreateErrorResponse(HttpStatusCode.InternalServerError, ex.Message);
            }

            return Task.FromResult(response);
        }

        [HttpGet]
        [Route("api/sets/export/{setName}")]
        public Task<HttpResponseMessage> Export([FromUri] string setName)
        {
            var response = default(HttpResponseMessage);
            using (var db = new CSET_Context())
            {
                var set = db.SETS
                    .Include(s => s.Set_Category_)
                    .Include(s => s.REQUIREMENT_SETS)
                        .ThenInclude(r => r.Requirement_)
                            .ThenInclude(rf => rf.REQUIREMENT_REFERENCES)
                                .ThenInclude(gf => gf.Gen_File_)
                    .Include(s => s.REQUIREMENT_SETS)
                        .ThenInclude(r => r.Requirement_)
                            .ThenInclude(r => r.REQUIREMENT_LEVELS)              
                    .Where(s => (s.Is_Displayed ?? false) && s.Set_Name == setName).FirstOrDefault();

                if (set == null)
                {
                    response = Request.CreateErrorResponse(HttpStatusCode.NotFound, $"A Set named '{setName}' was not found.");
                }
                response = Request.CreateResponse(set.ToExternalStandard());
            }

            return Task.FromResult(response);
        }
    }
}
