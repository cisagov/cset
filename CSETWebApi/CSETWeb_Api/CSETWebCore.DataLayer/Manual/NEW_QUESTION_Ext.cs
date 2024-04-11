using System.Linq;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.DataLayer.Model
{
    public partial class NEW_QUESTION 
    {
        public IQueryable<NEW_REQUIREMENT> NEW_REQUIREMENTs(CSETContext context)
        {            
                context.REQUIREMENT_QUESTIONS_SETS.Include("NEW_REQUIREMENT");
                var NewRs = from a in context.REQUIREMENT_QUESTIONS_SETS
                            join b in context.NEW_REQUIREMENT on a.Requirement_Id equals b.Requirement_Id
                            where a.Question_Id == this.Question_Id
                            select b;
                return NewRs;            
        }
    }
}
