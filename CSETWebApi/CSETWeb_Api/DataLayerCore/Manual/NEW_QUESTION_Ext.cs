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
        public IQueryable<NEW_REQUIREMENT> NEW_REQUIREMENT {
            get {
                
                CsetwebContext context = new CsetwebContext();
                context.REQUIREMENT_QUESTIONS.Include("NEW_REQUIREMENT");
                var NewRs = from a in context.REQUIREMENT_QUESTIONS
                            join b in context.NEW_REQUIREMENT on a.Requirement_Id equals b.Requirement_Id
                            where a.Question_Id == this.Question_Id
                            select b;
                return NewRs;

            }
            private set { }
        }
    }
}
