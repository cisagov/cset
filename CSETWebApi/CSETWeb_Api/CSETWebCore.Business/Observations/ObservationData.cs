//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Linq;
using CSETWebCore.Model.Observations;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using NLog.Fluent;
using NLog;

namespace CSETWebCore.Business.Observations
{
    /// <summary>
    /// 
    /// </summary>
    public class ObservationData
    {
        private int _observationId;
        private CSETContext _context;
        private FINDING _dbObservation;
        private Observation _webObservation;



        /// <summary>
        ///  The passed in finding is the source, if the ID does not exist it will create it. 
        ///  this will also push the data to the database and retrieve any auto identity id's 
        /// </summary>
        /// <param name="f">source finding</param>
        /// <param name="context">the data context to work on</param>
        public ObservationData(Observation f, CSETContext context)
        {
            _webObservation = f;

            //if (_webObservation.IsObservationEmpty())
            //{
            //    return;
            //}

            _context = context;

            _dbObservation = context.FINDING
                .Include(x => x.FINDING_CONTACT)
                .Where(x => x.Answer_Id == f.Answer_Id && x.Finding_Id == f.Observation_Id)
                .FirstOrDefault();

            if (_dbObservation == null)
            {
                var observation = new FINDING
                {
                    Answer_Id = f.Answer_Id,
                    Summary = f.Summary,
                    Impact = f.Impact,
                    Issue = f.Issue,
                    Recommendations = f.Recommendations,
                    Vulnerabilities = f.Vulnerabilities,
                    Resolution_Date = f.Resolution_Date,
                    Title = f.Title,
                    Type = f.Type,
                    Risk_Area = f.Risk_Area,
                    Sub_Risk = f.Sub_Risk,
                    Description = f.Description,
                    Citations = f.Citations,
                    ActionItems = f.ActionItems,
                    Supp_Guidance = f.Supp_Guidance
                };

                this._dbObservation = observation;
                context.FINDING.Add(observation);
            }

            TinyMapper.Bind<Observation, FINDING>(config => config.Bind(source => source.Observation_Id, target => target.Finding_Id));
            TinyMapper.Map(f, this._dbObservation);

            int importid = (f.Importance_Id == null) ? 1 : (int)f.Importance_Id;
            _dbObservation.Importance = context.IMPORTANCE.Where(x => x.Importance_Id == importid).FirstOrDefault();//note that 1 is the id of a low importance

            if (f.Observation_Contacts != null)
            {
                foreach (ObservationContact fc in f.Observation_Contacts)
                {
                    if (fc.Selected)
                    {
                        FINDING_CONTACT tmpC = _dbObservation.FINDING_CONTACT.Where(x => x.Assessment_Contact_Id == fc.Assessment_Contact_Id).FirstOrDefault();
                        if (tmpC == null)
                            _dbObservation.FINDING_CONTACT.Add(new FINDING_CONTACT() { Assessment_Contact_Id = fc.Assessment_Contact_Id, Finding_Id = f.Observation_Id });
                    }
                    else
                    {
                        FINDING_CONTACT tmpC = _dbObservation.FINDING_CONTACT.Where(x => x.Assessment_Contact_Id == fc.Assessment_Contact_Id).FirstOrDefault();
                        if (tmpC != null)
                            _dbObservation.FINDING_CONTACT.Remove(tmpC);
                    }
                }
            }
        }


        /// <summary>
        /// Will not create a new assessment
        /// if you pass a non-existent Observation then it will throw an exception
        /// </summary>
        /// <param name="observationId"></param>
        /// <param name="context"></param>
        public ObservationData(int observationId, CSETContext context)
        {
            _observationId = observationId;
            _context = context;

            this._dbObservation = context.FINDING.Where(x => x.Finding_Id == observationId).FirstOrDefault();
            if (_dbObservation == null)
            {
                throw new ApplicationException($"Cannot find observation_id: {observationId}");
            }
        }


        /// <summary>
        /// 
        /// </summary>
        public void Delete()
        {
            if (_dbObservation == null)
            {
                return;
            }
            try
            {
                _context.FINDING.Remove(_dbObservation);
                _context.SaveChanges();
            }
            catch (Exception ex)
            {
                LogManager.GetCurrentClassLogger().Error(ex);
            }

        }


        /// <summary>
        /// 
        /// </summary>
        public int Save()
        {
            // safety valve in case this was built without an answerid
            if (this._webObservation.Answer_Id == 0)
            {
                return 0;
            }

            if (this._webObservation.IsObservationEmpty())
                return 0;

            _context.SaveChanges();
            _webObservation.Observation_Id = _dbObservation.Finding_Id;
            return _dbObservation.Finding_Id;
        }
    }
}