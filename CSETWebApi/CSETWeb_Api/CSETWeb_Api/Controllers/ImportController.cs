//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.Helpers;
using BusinessLogic.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CSETWeb_Api.BusinessLogic.Helpers;
using DataLayerCore.Model;
using System.Threading.Tasks;
using System.Xml.Serialization;
using Hangfire;
using Hangfire.Console;
using Hangfire.Common;

namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class ImportController : ApiController
    {
        public ImportController() :base()
        {

        }
        [Route("api/import/{id}")]
        [HttpGet]
        public async Task<HttpResponseMessage> Get([FromUri] string id)
        {
            return await Task.Run(() =>
            {
                var state = Hangfire.States.AwaitingState.StateName;
                var messages = new List<string>();
                try
                {
                    var job = JobStorage.Current.GetMonitoringApi().JobDetails(id);
                    if (job != null)

                        state = (job.History.Where(s => s.StateName == Hangfire.States.SucceededState.StateName).OrderByDescending(s => s.CreatedAt).FirstOrDefault() ??
                            job.History.Where(s => s.StateName == Hangfire.States.FailedState.StateName).OrderByDescending(s => s.CreatedAt).FirstOrDefault() ??
                            job.History.Where(s => s.StateName == Hangfire.States.ProcessingState.StateName).OrderByDescending(s => s.CreatedAt).FirstOrDefault())?.StateName ?? state;
                    {
                        var processingRecord = job.History.LastOrDefault(s => s.StateName == Hangfire.States.ProcessingState.StateName);
                        if (processingRecord != null)
                        {
                            var timestamp = JobHelper.DeserializeDateTime(processingRecord.Data["StartedAt"]);
                            messages = JobStorage.Current.GetConsoleApi().GetLines(id, timestamp, Hangfire.Console.Monitoring.LineType.Text).OfType<Hangfire.Console.Monitoring.TextLineDto>().Select(s => s.Text).ToList();
                        }
                    }

                }
                catch
                {

                }
                return Request.CreateResponse(new { state = state, errors = messages });
            });
        }

        /// <summary>
        /// Import new standards into CSET
        /// </summary>
        public async Task<HttpResponseMessage> Post([FromBody] ExternalStandard externalStandard)
        {
            return await Task.Run(() =>
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        var id = BackgroundJob.Enqueue(() => HangfireExecutor.SaveImport(externalStandard, null));
                        return Request.CreateResponse(new { id });
                    }
                    else
                    {
                        return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ModelState);
                    }

                }
                catch (Exception)
                {
                    return Request.CreateResponse();
                }
            });
        }
    }
}


