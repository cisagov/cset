using System;
using System.Linq;
using CSETWebCore.Model.Question;
using CSETWebCore.DataLayer;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;

namespace CSETWebCore.Business.Findings
{
    public class FindingData
    {
        private CSETContext context;

        private FINDING dbFinding;
        private Finding webFinding;
        private int finding_Id;

        /// <summary>
        ///  The passed in finding is the source, if the ID does not exist it will create it. 
        ///  this will also push the data to the database and retrieve any auto identity id's 
        /// </summary>
        /// <param name="f">source finding</param>
        /// <param name="context">the data context to work on</param>
        public FindingData(Finding f, CSETContext context)
        {
            //get all the contacts in this assessment
            //get all the contexts on this finding
            this.webFinding = f;

            if (f.IsFindingEmpty())
            {
                return;
            }

            this.context = context;

            this.dbFinding = context.FINDING
                .Include(x => x.FINDING_CONTACT)
                .Where(x => x.Answer_Id == f.Answer_Id && x.Finding_Id == f.Finding_Id)
                .FirstOrDefault();
            if (dbFinding == null)
            {
                var finding = new FINDING
                {
                    Answer_Id = f.Answer_Id,
                    Summary = f.Summary,
                    Impact = f.Impact,
                    Issue = f.Issue,
                    Recommendations = f.Recommendations,
                    Vulnerabilities = f.Vulnerabilities,
                    Resolution_Date = f.Resolution_Date
                };

                this.dbFinding = finding;
                context.FINDING.Add(finding);
            }

            TinyMapper.Bind<Finding, FINDING>();
            TinyMapper.Map(f, this.dbFinding);

            int importid = (f.Importance_Id == null) ? 1 : (int)f.Importance_Id;
            this.dbFinding.Importance_ = context.IMPORTANCE.Where(x => x.Importance_Id == importid).FirstOrDefault();//note that 1 is the id of a low importance

            if (f.Finding_Contacts != null)
            {
                foreach (FindingContact fc in f.Finding_Contacts)
                {
                    if (fc.Selected)
                    {
                        FINDING_CONTACT tmpC = dbFinding.FINDING_CONTACT.Where(x => x.Assessment_Contact_Id == fc.Assessment_Contact_Id).FirstOrDefault();
                        if (tmpC == null)
                            dbFinding.FINDING_CONTACT.Add(new FINDING_CONTACT() { Assessment_Contact_Id = fc.Assessment_Contact_Id, Finding_Id = f.Finding_Id });
                    }
                    else
                    {
                        FINDING_CONTACT tmpC = dbFinding.FINDING_CONTACT.Where(x => x.Assessment_Contact_Id == fc.Assessment_Contact_Id).FirstOrDefault();
                        if (tmpC != null)
                            dbFinding.FINDING_CONTACT.Remove(tmpC);
                    }
                }
            }
        }

        /// <summary>
        /// Will not create a new assessment
        /// if you pass a non-existent finding then it will throw an exception
        /// </summary>
        /// <param name="finding_Id"></param>
        /// <param name="context"></param>
        public FindingData(int finding_Id, CSETContext context)
        {
            this.finding_Id = finding_Id;
            this.context = context;
            this.dbFinding = context.FINDING.Where(x => x.Finding_Id == finding_Id).FirstOrDefault();
            if (dbFinding == null)
            {
                throw new ApplicationException("Cannot find finding_id" + finding_Id);
            }
        }

        public void Delete()
        {
            dbFinding.FINDING_CONTACT.ToList().ForEach(s => context.FINDING_CONTACT.Remove(s));
            context.FINDING.Remove(dbFinding);
            context.SaveChanges();
        }

        public void Save()
        {
            // safety valve in case this was built without an answerid
            if (this.webFinding.Answer_Id == 0)
            {
                return;
            }

            if (this.webFinding.IsFindingEmpty())
                return;

            context.SaveChanges();
            webFinding.Finding_Id = dbFinding.Finding_Id;
        }
    }
}