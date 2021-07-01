using CSETWebCore.DataLayer;
using CSETWebCore.Model.Findings;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Findings
{
    public class FindingsManager
    {
        private int _assessmentId;

        /** I need to get the list of contacts
        *  provide a list of all the available contacts 
        *  allow the user to select from the list
        *  restrict this to one finding only
        */

        private CSETContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentId"></param>
        public FindingsManager(CSETContext context, int assessmentId)
        {
            _assessmentId = assessmentId;
            _context = context;

            TinyMapper.Bind<FINDING, Finding>();
            TinyMapper.Bind<FINDING_CONTACT, FindingContact>();
            TinyMapper.Bind<IMPORTANCE, Importance>();
            TinyMapper.Bind<ASSESSMENT_CONTACTS, FindingContact>();
            TinyMapper.Bind<Finding, FindingContact>();
            TinyMapper.Bind<Finding, Finding>();
            TinyMapper.Bind<FindingContact, FindingContact>();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="finding"></param>
        public void DeleteFinding(Finding finding)
        {
            FindingData fm = new FindingData(finding, _context);
            fm.Delete();
            fm.Save();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="finding"></param>
        public void UpdateFinding(Finding finding)
        {
            FindingData fm = new FindingData(finding, _context);
            fm.Save();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="answerId"></param>
        /// <returns></returns>
        public List<Finding> AllFindings(int answerId)
        {
            List<Finding> findings = new List<Finding>();

            var xxx = _context.FINDING
                .Where(x => x.Answer_Id == answerId)
                .Include(i => i.Importance_)
                .Include(k => k.FINDING_CONTACT)
                .ToList();

            foreach (FINDING f in xxx)
            {
                Finding webF = new Finding();
                webF.Finding_Contacts = new List<FindingContact>();
                webF.Summary = f.Summary;
                webF.Finding_Id = f.Finding_Id;
                webF.Answer_Id = answerId;
                TinyMapper.Map(f, webF);
                if (f.Importance_ == null)
                    webF.Importance = new Importance()
                    {
                        Importance_Id = 1,
                        Value = Constants.Constants.SAL_LOW
                    };
                else
                    webF.Importance = TinyMapper.Map<IMPORTANCE, Importance>(f.Importance_);

                foreach (FINDING_CONTACT fc in f.FINDING_CONTACT)
                {
                    FindingContact webFc = TinyMapper.Map<FINDING_CONTACT, FindingContact>(fc);

                    webFc.Selected = (fc != null);
                    webF.Finding_Contacts.Add(webFc);
                }
                findings.Add(webF);
            }
            return findings;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="findingId"></param>
        /// <param name="answerId"></param>
        /// <returns></returns>
        public Finding GetFinding(int findingId, int answerId = 0)
        {
            Finding webF;

            if (findingId != 0)
            {
                FINDING f = _context.FINDING
                    .Where(x => x.Finding_Id == findingId)
                    .Include(fc => fc.FINDING_CONTACT)
                    .FirstOrDefault();

                var q = _context.ANSWER.Where(x => x.Answer_Id == f.Answer_Id).FirstOrDefault();

                webF = TinyMapper.Map<Finding>(f);
                webF.Question_Id = q != null ? q.Question_Or_Requirement_Id : 0;
                webF.Finding_Contacts = new List<FindingContact>();
                foreach (var contact in _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == _assessmentId))
                {
                    FindingContact webContact = TinyMapper.Map<FindingContact>(contact);
                    webContact.Name = contact.PrimaryEmail + " -- " + contact.FirstName + " " + contact.LastName;
                    webContact.Selected = (f.FINDING_CONTACT.Where(x => x.Assessment_Contact_Id == contact.Assessment_Contact_Id).FirstOrDefault() != null);
                    webF.Finding_Contacts.Add(webContact);
                }
            }
            else
            {
                var q = _context.ANSWER.Where(x => x.Answer_Id == answerId).FirstOrDefault();

                FINDING f = new FINDING()
                {
                    Answer_Id = answerId
                };


                _context.FINDING.Add(f);
                _context.SaveChanges();
                webF = TinyMapper.Map<Finding>(f);
                webF.Finding_Contacts = new List<FindingContact>();
                foreach (var contact in _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == _assessmentId))
                {
                    FindingContact webContact = TinyMapper.Map<FindingContact>(contact);
                    webContact.Finding_Id = f.Finding_Id;
                    webContact.Name = contact.PrimaryEmail + " -- " + contact.FirstName + " " + contact.LastName;
                    webContact.Selected = false;
                    webF.Finding_Contacts.Add(webContact);
                }
            }

            return webF;
        }
    }
}