using System;
using System.Linq;
using CSETWebCore.Model.Findings;
using CSETWebCore.DataLayer;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;

namespace CSETWebCore.Business.Findings
{
    /// <summary>
    /// 
    /// </summary>
    public class FindingData
    {
        private CSETContext _context;
        private int _findingId;

        private FINDING _dbFinding;
        private Finding _webFinding;



        /// <summary>
        ///  The passed in finding is the source, if the ID does not exist it will create it. 
        ///  this will also push the data to the database and retrieve any auto identity id's 
        /// </summary>
        /// <param name="f">source finding</param>
        /// <param name="context">the data context to work on</param>
        public FindingData(Finding f, CSETContext context)
        {
            _webFinding = f;

            if (_webFinding.IsFindingEmpty())
            {
                // Commented out because some finding deletions were throwing errors - RKW
                // return;
            }

            _context = context;

            _dbFinding = context.FINDING
                .Include(x => x.FINDING_CONTACT)
                .Where(x => x.Answer_Id == f.Answer_Id && x.Finding_Id == f.Finding_Id)
                .FirstOrDefault();

            if (_dbFinding == null)
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

                this._dbFinding = finding;
                context.FINDING.Add(finding);
            }

            TinyMapper.Bind<Finding, FINDING>();
            TinyMapper.Map(f, this._dbFinding);

            int importid = (f.Importance_Id == null) ? 1 : (int)f.Importance_Id;
            _dbFinding.Importance_ = context.IMPORTANCE.Where(x => x.Importance_Id == importid).FirstOrDefault();//note that 1 is the id of a low importance

            if (f.Finding_Contacts != null)
            {
                foreach (FindingContact fc in f.Finding_Contacts)
                {
                    if (fc.Selected)
                    {
                        FINDING_CONTACT tmpC = _dbFinding.FINDING_CONTACT.Where(x => x.Assessment_Contact_Id == fc.Assessment_Contact_Id).FirstOrDefault();
                        if (tmpC == null)
                            _dbFinding.FINDING_CONTACT.Add(new FINDING_CONTACT() { Assessment_Contact_Id = fc.Assessment_Contact_Id, Finding_Id = f.Finding_Id });
                    }
                    else
                    {
                        FINDING_CONTACT tmpC = _dbFinding.FINDING_CONTACT.Where(x => x.Assessment_Contact_Id == fc.Assessment_Contact_Id).FirstOrDefault();
                        if (tmpC != null)
                            _dbFinding.FINDING_CONTACT.Remove(tmpC);
                    }
                }
            }
        }


        /// <summary>
        /// Will not create a new assessment
        /// if you pass a non-existent finding then it will throw an exception
        /// </summary>
        /// <param name="findingId"></param>
        /// <param name="context"></param>
        public FindingData(int findingId, CSETContext context)
        {
            _findingId = findingId;
            _context = context;

            this._dbFinding = context.FINDING.Where(x => x.Finding_Id == findingId).FirstOrDefault();
            if (_dbFinding == null)
            {
                throw new ApplicationException("Cannot find finding_id" + findingId);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        public void Delete()
        {
            if (_dbFinding == null)
            {
                return;
            }

            _dbFinding.FINDING_CONTACT.ToList().ForEach(s => _context.FINDING_CONTACT.Remove(s));
            _context.FINDING.Remove(_dbFinding);
            _context.SaveChanges();
        }


        /// <summary>
        /// 
        /// </summary>
        public void Save()
        {
            // safety valve in case this was built without an answerid
            if (this._webFinding.Answer_Id == 0)
            {
                return;
            }

            if (this._webFinding.IsFindingEmpty())
                return;

            _context.SaveChanges();
            _webFinding.Finding_Id = _dbFinding.Finding_Id;
        }
    }
}