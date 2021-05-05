using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace CSETWebCore.DataLayer
{
    public partial class NEW_REQUIREMENT
    {
        public IQueryable<NEW_QUESTION> NEW_QUESTIONs()
        {
                CSET_Context context = new CSET_Context();
                context.REQUIREMENT_QUESTIONS.Include("NEW_QUESTION");
                var NewRs = from a in context.REQUIREMENT_QUESTIONS
                            join b in context.NEW_QUESTION on a.Question_Id equals b.Question_Id
                            where a.Requirement_Id == this.Requirement_Id
                            select b;
                return NewRs;
        }

        public IQueryable<SETS> SETs()
        {
            CSET_Context context = new CSET_Context();
            context.REQUIREMENT_SETS.Include("SETS");
            var NewRs = from a in context.REQUIREMENT_SETS
                        join b in context.SETS on a.Set_Name equals b.Set_Name
                        where a.Requirement_Id == this.Requirement_Id
                        select b;
            return NewRs;
        }
    }
}