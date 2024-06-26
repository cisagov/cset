//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Observations;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Observations
{
    public class ObservationsManager
    {
        private int _assessmentId;

        /** I need to get the list of contacts
        *  provide a list of all the available contacts 
        *  allow the user to select from the list
        *  restrict this to one observation only
        */

        private CSETContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentId"></param>
        public ObservationsManager(CSETContext context, int assessmentId)
        {
            _assessmentId = assessmentId;
            _context = context;

            TinyMapper.Bind<FINDING, Observation>();
            TinyMapper.Bind<FINDING_CONTACT, ObservationContact>(config => config.Bind(source => source.Finding_Id, target => target.Observation_Id));
            TinyMapper.Bind<IMPORTANCE, Importance>();
            TinyMapper.Bind<ASSESSMENT_CONTACTS, ObservationContact>();
            TinyMapper.Bind<Observation, ObservationContact>();
            TinyMapper.Bind<Observation, Observation>();
            TinyMapper.Bind<ObservationContact, ObservationContact>();
        }


        /// <summary>
        /// Returns a list of Observations (FINDING databse records) for an answer
        /// </summary>
        public List<Observation> AllObservations(int answerId)
        {
            List<Observation> observations = new List<Observation>();

            var observationsForAnswer = _context.FINDING
                .Where(x => x.Answer_Id == answerId)
                .Include(i => i.Importance)
                .Include(k => k.FINDING_CONTACT)
                .ToList();

            foreach (FINDING o in observationsForAnswer)
            {
                Observation obs = new Observation();
                obs.Observation_Contacts = new List<ObservationContact>();
                obs.Summary = o.Summary;
                obs.Observation_Id = o.Finding_Id;
                obs.Answer_Id = answerId;
                TinyMapper.Map(o, obs);
                if (o.Importance == null)
                    obs.Importance = new Importance()
                    {
                        Importance_Id = 1,
                        Value = Constants.Constants.SAL_LOW
                    };
                else
                    obs.Importance = TinyMapper.Map<IMPORTANCE, Importance>(o.Importance);

                foreach (FINDING_CONTACT fc in o.FINDING_CONTACT)
                {
                    ObservationContact webFc = TinyMapper.Map<FINDING_CONTACT, ObservationContact>(fc);

                    webFc.Observation_Id = fc.Finding_Id;
                    webFc.Selected = (fc != null);
                    obs.Observation_Contacts.Add(webFc);
                }
                observations.Add(obs);
            }
            return observations;
        }


        /// <summary>
        /// 
        /// </summary>
        public Observation GetObservation(int observationId, int answerId = 0)
        {
            // look for an existing FINDING record.  If not, create one.
            FINDING f = _context.FINDING
                    .Where(x => x.Finding_Id == observationId)
                    .Include(fc => fc.FINDING_CONTACT)
                    .FirstOrDefault();

            if (f == null)
            {
                f = new FINDING()
                {
                    Answer_Id = answerId
                };

                _context.FINDING.Add(f);
                _context.SaveChanges();
            }


            // Create an Observation object from the FINDING and joined tables
            Observation obs;
            var q = _context.ANSWER.Where(x => x.Answer_Id == f.Answer_Id).FirstOrDefault();

            obs = TinyMapper.Map<Observation>(f);
            obs.Observation_Id = f.Finding_Id;
            obs.Question_Id = q != null ? q.Question_Or_Requirement_Id : 0;

            obs.Observation_Contacts = new List<ObservationContact>();
            foreach (var contact in _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == _assessmentId))
            {
                ObservationContact webContact = TinyMapper.Map<ObservationContact>(contact);
                webContact.Name = contact.PrimaryEmail + " -- " + contact.FirstName + " " + contact.LastName;
                webContact.Selected = (f.FINDING_CONTACT.Where(x => x.Assessment_Contact_Id == contact.Assessment_Contact_Id).FirstOrDefault() != null);
                obs.Observation_Contacts.Add(webContact);
            }

            return obs;
        }


        /// <summary>
        /// Deletes an Observation (FINDING record)
        /// </summary>
        /// <param name="observation"></param>
        public void DeleteObservation(Observation observation)
        {
            ObservationData fm = new ObservationData(observation, _context);
            fm.Delete();
            fm.Save();
        }


        /// <summary>
        /// Updates an Observation in its FINDING database record
        /// </summary>
        /// <param name="observation"></param>
        public int UpdateObservation(Observation observation, bool merge)
        {
            ObservationData fm = new ObservationData(observation, _context);
            int id = fm.Save();

            if (merge == true)
            {
                var contactList = new List<FINDING_CONTACT>();
                if (observation.Observation_Contacts != null)
                {
                    foreach (var contact in observation.Observation_Contacts)
                    {
                        var previousContact = _context.FINDING_CONTACT.Where(x => x.Assessment_Contact_Id == contact.Assessment_Contact_Id).FirstOrDefault();
                        var userId = _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Contact_Id == contact.Assessment_Contact_Id).Select(x => x.UserId).FirstOrDefault();
                        var newContactId = _context.ASSESSMENT_CONTACTS.Where(x => x.UserId == userId && x.Assessment_Id == _assessmentId).Select(x => x.Assessment_Contact_Id).FirstOrDefault();


                        FINDING_CONTACT newContact = new FINDING_CONTACT()
                        {
                            Finding_Id = id,
                            Assessment_Contact_Id = newContactId
                        };
                        contactList.Add(newContact);
                    }

                    _context.FINDING_CONTACT.AddRange(contactList);
                    _context.SaveChanges();

                }

            }
            // IF MERGE
            // IF fm._webObservation.ObservationContacts > 0 AND SELECT Finding_Contact (Where x.Finding_Id == id)
            // _context.add(fm._webObservation.ObservationContact) <-- Maybe add a new function here inside the business and not manager? Idk.
            // _context.save()
            // 
            return id;
        }


        /// <summary>
        /// 
        /// </summary>
        public List<ActionItems> GetActionItems(int parentId, int observation_id)
        {
            var actionItems = new List<ActionItems>();

            var table = from questions in _context.MATURITY_QUESTIONS
                        join actions in _context.ISE_ACTIONS on questions.Mat_Question_Id equals actions.Mat_Question_Id
                        join o in _context.ISE_ACTIONS_FINDINGS on new { Mat_Question_Id = questions.Mat_Question_Id, Finding_Id = observation_id }
                            equals new { Mat_Question_Id = o.Mat_Question_Id, Finding_Id = o.Finding_Id }
                           into overrides
                        from o in overrides.DefaultIfEmpty()
                        orderby questions.Mat_Question_Id ascending
                        where questions.Parent_Question_Id == parentId
                        select new { actions = actions, overrides = o };
            foreach (var row in table.ToList())
            {
                actionItems.Add(
                    new ActionItems()
                    {
                        Question_Id = row.actions.Mat_Question_Id,
                        Description = row.actions.Description,
                        Action_Items = row.overrides == null
                        ? row.actions.Action_Items : row.overrides.Action_Items_Override,
                        Regulatory_Citation = row.actions.Regulatory_Citation
                    }
                );
            }
            return actionItems;
        }


        /// <summary>
        /// 
        /// </summary>
        public async Task<List<Acet_GetActionItemsForReportResult>> GetActionItemsReport(int assessment_id, int examLevel)
        {
            int additionalExamLevel = 17; //initialized as SCUEP
            if (examLevel == 18) //if CORE, include CORE+ in the stored proc
            {
                additionalExamLevel = 19; //CORE+
            }

            var data = await _context.Procedures.Acet_GetActionItemsForReportAsync(assessment_id, examLevel, additionalExamLevel);
            return data;

        }


        /// <summary>
        /// 
        /// </summary>
        public void UpdateIssues(ActionItemTextUpdate items)
        {
            foreach (var item in items.actionTextItems)
            {
                var save = _context.ISE_ACTIONS_FINDINGS.Where(x => x.Finding_Id == items.observation_Id && x.Mat_Question_Id == item.Mat_Question_Id).FirstOrDefault();
                if (save == null)
                {
                    _context.ISE_ACTIONS_FINDINGS.Add(new ISE_ACTIONS_FINDINGS()
                    {
                        Mat_Question_Id = item.Mat_Question_Id,
                        Finding_Id = items.observation_Id,
                        Action_Items_Override = item.ActionItemOverrideText
                    });
                    _context.SaveChanges();
                }
                else
                {
                    save.Action_Items_Override = item.ActionItemOverrideText;
                    _context.SaveChanges();
                }
            }
        }
    }
}