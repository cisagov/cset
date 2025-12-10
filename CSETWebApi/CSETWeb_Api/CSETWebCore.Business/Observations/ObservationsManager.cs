//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
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
        /// Returns a list of assessment-level Observations (not attached to any ANSWER)
        /// </summary>
        public List<Observation> GetAssessmentLevelObservations()
        {
            List<Observation> observations = new List<Observation>();

            var obsList = _context.FINDING
                .Where(x => x.Assessment_Id == _assessmentId && x.Answer_Id == null)
                .Include(i => i.Importance)
                .ToList();

            return ToObservationList(obsList, _assessmentId, null);
        }


        /// <summary>
        /// Returns a list of Observations for all answers in an assessment.
        /// Assessment-level Observations are not returned.  
        /// </summary>
        public List<Observation> GetAnswerLevelObservations(int assessmentId)
        {
            var obsList = _context.FINDING
                .Include(f => f.Answer)
                .Include(f => f.Importance)
                .Include(k => k.FINDING_CONTACT)
                .Where(x => x.Answer.Assessment_Id == assessmentId)
                .ToList();

            return ToObservationList(obsList, _assessmentId, null);
        }


        /// <summary>
        /// Returns a list of Observations (FINDING databse records) for a single answer
        /// </summary>
        public List<Observation> GetObservationsForAnswer(int answerId)
        {
            List<Observation> observations = new List<Observation>();

            var observationsForAnswer = _context.FINDING
                .Where(x => x.Answer_Id == answerId)
                .Include(i => i.Importance)
                .Include(k => k.FINDING_CONTACT)
                .ToList();

            return ToObservationList(observationsForAnswer, null, answerId);
        }


        /// <summary>
        /// Returns the specified Observation or returns null.
        /// </summary>
        public Observation GetObservation(int observationId)
        {
            var f = _context.FINDING
                .Where(x => x.Finding_Id == observationId)
                .Include(i => i.Importance)
                .Include(fc => fc.FINDING_CONTACT)
                .ToList();

            if (f.Count == 0)
            {
                return null;
            }

            var list = ToObservationList(f, null, null);

            return list.First();
        }


        /// <summary>
        /// Converts a list of FINDING records to a list of Observation instances.
        /// </summary>
        private List<Observation> ToObservationList(List<FINDING> list, int? assessmentId, int? answerId)
        {
            if (assessmentId != null && answerId != null)
            {
                throw new ArgumentException("Cannot save an Observation with both assessment and answer IDs");
            }


            // get a list of all the questions for the list of FINDING
            var dictTitles = GetQuestionTitlesForObservations(list);


            List<Observation> observations = new List<Observation>();

            foreach (FINDING o in list)
            {
                Observation obs = new Observation();
                obs.Observation_Contacts = new List<ObservationContact>();
                obs.Summary = o.Summary;
                obs.Observation_Id = o.Finding_Id;

                obs.Assessment_Id = assessmentId;
                obs.Answer_Id = answerId;

                if (dictTitles.TryGetValue(obs.Observation_Id, out var record))
                {
                    obs.Question_Title = dictTitles[obs.Observation_Id];
                }

                obs.AnswerLevel = (obs.Assessment_Id == null && obs.Answer_Id != null);

                TinyMapper.Map(o, obs);

                if (o.Importance == null)
                {
                    obs.Importance = new Importance()
                    {
                        Importance_Id = 1,
                        Value = Constants.Constants.SAL_LOW
                    };
                }
                else
                {
                    obs.Importance = TinyMapper.Map<IMPORTANCE, Importance>(o.Importance);
                }

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
        /// Builds a dictionary of question titles for observation IDs
        /// (if the Observation happens to be attached to a question)
        /// </summary>
        /// <param name="findings"></param>
        /// <returns></returns>
        private Dictionary<int, string> GetQuestionTitlesForObservations(List<FINDING> findings)
        {
            var titles = new Dictionary<int, string>();

            // Get all answers upfront, filtering out nulls
            var answers = findings
                .Where(f => f.Answer_Id != null && f.Answer != null)
                .Select(f => f.Answer)
                .ToList();

            if (!answers.Any())
                return titles;

            // Batch load all question types
            var maturityQuestions = LoadMaturityQuestions(answers);
            var standardQuestions = LoadStandardQuestions(answers);
            var requirements = LoadRequirements(answers);

            // Map findings to titles
            foreach (var finding in findings.Where(f => f.Answer_Id != null && f.Answer != null))
            {
                var answer = finding.Answer;
                var questionId = answer.Question_Or_Requirement_Id;

                string title = null;

                if (answer.Is_Maturity == true)
                    title = maturityQuestions.GetValueOrDefault(questionId);
                else if (answer.Is_Requirement == true)
                    title = requirements.GetValueOrDefault(questionId);
                else if (answer.Question_Type == "Question")
                    title = standardQuestions.GetValueOrDefault(questionId);

                if (title != null)
                    titles[finding.Finding_Id] = title;
            }

            return titles;
        }

        private Dictionary<int, string> LoadMaturityQuestions(List<ANSWER> answers)
        {
            var ids = answers
                .Where(a => a.Is_Maturity == true)
                .Select(a => a.Question_Or_Requirement_Id)
                .Distinct()
                .ToList();

            return _context.MATURITY_QUESTIONS
                .Where(q => ids.Contains(q.Mat_Question_Id))
                .ToDictionary(q => q.Mat_Question_Id, q => q.Question_Title);
        }

        private Dictionary<int, string> LoadStandardQuestions(List<ANSWER> answers)
        {
            var ids = answers
                .Where(a => a.Question_Type == "Question")
                .Select(a => a.Question_Or_Requirement_Id)
                .Distinct()
                .ToList();

            return _context.NEW_QUESTION
                .Where(q => ids.Contains(q.Question_Id))
                .ToDictionary(q => q.Question_Id, q => q.Simple_Question ?? "");
        }

        private Dictionary<int, string> LoadRequirements(List<ANSWER> answers)
        {
            var ids = answers
                .Where(a => a.Is_Requirement == true)
                .Select(a => a.Question_Or_Requirement_Id)
                .Distinct()
                .ToList();

            return _context.NEW_REQUIREMENT
                .Where(q => ids.Contains(q.Requirement_Id))
                .ToDictionary(q => q.Requirement_Id, q => q.Requirement_Title);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public Observation CreateObservationForAnswer(int answerId)
        {
            var obs = new Observation();
            obs.Answer_Id = answerId;
            obs.AnswerLevel = true;

            return obs;
        }


        /// <summary>
        /// Updates an Observation in its FINDING database record
        /// </summary>
        /// <param name="observation"></param>
        public int UpdateObservation(Observation observation)
        {
            ObservationData fm = new ObservationData(observation, _context);
            int id = fm.Save();
            return id;
        }


        /// <summary>
        /// Deletes an Observation (FINDING record) by its primary key
        /// </summary>
        /// <param name="observationId"></param>
        public void DeleteObservation(int observationId)
        {
            var obs = _context.FINDING.FirstOrDefault(x => x.Finding_Id == observationId);
            if (obs != null)
            {
                _context.FINDING.Remove(obs);
                _context.SaveChanges();
            }
        }


        /// <summary>
        /// Creates an Observation based on maturity question properties.
        /// </summary>
        public void BuildAutoObservation(Model.Question.Answer answer)
        {
            var questionId = answer.QuestionId;


            // see if there is an existing auto observation
            var existingAutoObs = _context.FINDING.Where(x => x.Answer_Id == answer.AnswerId && x.Auto_Generated == Constants.Constants.ObsCreatedByVadr).FirstOrDefault();
            if (existingAutoObs != null)
            {
                return;
            }


            // create new observation record
            var newObs = CreateObservationForAnswer((int)answer.AnswerId);


            // get OBS-properties for the question
            var props = _context.MATURITY_QUESTION_PROPS.Where(x => x.Mat_Question_Id == questionId && x.PropertyName.StartsWith("OBS-")).ToList();
            newObs.Summary = props.Where(x => x.PropertyName == "OBS-DISCOVERY").FirstOrDefault()?.PropertyValue ?? "";
            newObs.Issue = props.Where(x => x.PropertyName == "OBS-RISK-STATEMENT").FirstOrDefault()?.PropertyValue ?? "";
            newObs.Recommendations = props.Where(x => x.PropertyName == "OBS-RECOMMENDATION").FirstOrDefault()?.PropertyValue ?? "";


            // mark the observation as created by VADR so that we can find it easily to delete 
            newObs.Auto_Generated = Constants.Constants.ObsCreatedByVadr;

            UpdateObservation(newObs);
        }


        /// <summary>
        /// Deletes all "Auto" Observations attached to the specified Answer.
        /// </summary>
        /// <param name="answer"></param>
        public void DeleteAutoObservation(Model.Question.Answer answer)
        {
            var listObs = _context.FINDING.Where(x => x.Answer_Id == answer.AnswerId && x.Auto_Generated == Constants.Constants.ObsCreatedByVadr).ToList();
            _context.RemoveRange(listObs);
            _context.SaveChanges();
        }


        /// <summary>
        /// If the user adds an observation to a never-answered question, this
        /// will create an ANSWER record to attach the Observation to.
        /// </summary>
        public int BuildEmptyAnswer(int assessmentId, Observation obs)
        {
            if (obs.Question_Id == null)
            {
                return 0;
            }

            var ans = new ANSWER();
            ans.Assessment_Id = assessmentId;
            ans.Answer_Id = 0;
            ans.Question_Or_Requirement_Id = (int)obs.Question_Id;
            ans.Answer_Text = "U";
            ans.Question_Type = obs.Question_Type;
            ans.Mark_For_Review = false;
            ans.Reviewed = false;
            ans.Component_Guid = System.Guid.Empty;

            _context.ANSWER.Add(ans);
            _context.SaveChanges();
            return ans.Answer_Id;
        }
    }
}