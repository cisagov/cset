using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace DataLayerCore.Model
{
    public partial class NEW_QUESTION 
    {
        public IQueryable<NEW_REQUIREMENT> NEW_REQUIREMENT
        {
            get
            {

                CSET_Context context = new CSET_Context();
                context.REQUIREMENT_QUESTIONS.Include("NEW_REQUIREMENT");
                var NewRs = from a in context.REQUIREMENT_QUESTIONS
                            join b in context.NEW_REQUIREMENT on a.Requirement_Id equals b.Requirement_Id
                            where a.Question_Id == this.Question_Id
                            select b;
                return NewRs;

            }
            private set { }
        }

        public IQueryable<SETS> SETS
        {
            get
            {
                CSET_Context context = new CSET_Context();
                context.REQUIREMENT_QUESTIONS.Include("NEW_QUESTION_SETS");
                var NewRs = from a in context.NEW_QUESTION_SETS
                            join b in context.SETS on a.Set_Name equals b.Set_Name
                            where a.Question_Id == this.Question_Id
                            select b;
                return NewRs;
            }
            private set { }
        }
    }
}
