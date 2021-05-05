using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Model.Question;
using CSETWebCore.DataLayer;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;

namespace CSETWebCore.Business.Findings
{
    public class FindingsManager
    {
        private int assessment_id;

        /** I need to get the list of contacts
        *  provide a list of all the available contacts 
        *  allow the user to select from the list
        *  restrict this to one finding only
        */
        private int answer_id = 0;
        private CSET_Context assessmentContext;

        public FindingsManager(CSET_Context assessmentContext, int assessment_id, int answer_id)
        {
            this.assessment_id = assessment_id;
            this.answer_id = answer_id;
            this.assessmentContext = assessmentContext;
            TinyMapper.Bind<FINDING, Finding>();
            TinyMapper.Bind<FINDING_CONTACT, FindingContact>();
            TinyMapper.Bind<IMPORTANCE, Importance>();
            TinyMapper.Bind<ASSESSMENT_CONTACTS, FindingContact>();
            TinyMapper.Bind<Finding, FindingContact>();
            TinyMapper.Bind<Finding, Finding>();
            TinyMapper.Bind<FindingContact, FindingContact>();
        }

        public void DeleteFinding(Finding finding)
        {
            FindingData fm = new FindingData(finding, assessmentContext);
            fm.Delete();
            fm.Save();
        }

        public void UpdateFinding(Finding finding)
        {
            FindingData fm = new FindingData(finding, assessmentContext);
            fm.Save();
        }

        public List<Finding> AllFindings()
        {
            List<Finding> findings = new List<Finding>();

            var xxx = assessmentContext.FINDING
                .Where(x => x.Answer_Id == this.answer_id)
                .Include(i => i.Importance_)
                .Include(k => k.FINDING_CONTACT)
                .ToList();

            foreach (FINDING f in xxx)
            {
                Finding webF = new Finding();
                webF.Finding_Contacts = new List<FindingContact>();
                webF.Summary = f.Summary;
                webF.Finding_Id = f.Finding_Id;
                webF.Answer_Id = this.answer_id;
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

        public Finding GetFinding(int finding_id)
        {
            Finding webF;
            if (finding_id != 0)
            {
                FINDING f = assessmentContext.FINDING
                    .Where(x => x.Finding_Id == finding_id)
                    .Include(fc => fc.FINDING_CONTACT)
                    .FirstOrDefault();

                var q = assessmentContext.ANSWER.Where(x => x.Answer_Id == this.answer_id).FirstOrDefault();

                webF = TinyMapper.Map<Finding>(f);
                webF.Question_Id = q != null ? q.Question_Or_Requirement_Id : 0;
                webF.Finding_Contacts = new List<FindingContact>();
                foreach (var contact in assessmentContext.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == assessment_id))
                {
                    FindingContact webContact = TinyMapper.Map<FindingContact>(contact);
                    webContact.Name = contact.PrimaryEmail + " -- " + contact.FirstName + " " + contact.LastName;
                    webContact.Selected = (f.FINDING_CONTACT.Where(x => x.Assessment_Contact_Id == contact.Assessment_Contact_Id).FirstOrDefault() != null);
                    webF.Finding_Contacts.Add(webContact);
                }
            }
            else
            {
                var q = assessmentContext.ANSWER.Where(x => x.Answer_Id == this.answer_id).FirstOrDefault();

                FINDING f = new FINDING()
                {
                    Answer_Id = answer_id
                };


                assessmentContext.FINDING.Add(f);
                assessmentContext.SaveChanges();
                webF = TinyMapper.Map<Finding>(f);
                webF.Finding_Contacts = new List<FindingContact>();
                foreach (var contact in assessmentContext.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == assessment_id))
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