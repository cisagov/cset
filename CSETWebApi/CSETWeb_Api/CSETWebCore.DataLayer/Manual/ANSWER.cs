using System.Linq;

namespace CSETWebCore.DataLayer.Model
{
    public partial class ANSWER
    {
        public IQueryable<DOCUMENT_FILE> DOCUMENT_FILEs(CSETContext context)
        {   
            var NewRs = from a in context.DOCUMENT_ANSWERS
                        join b in context.DOCUMENT_FILE on a.Document_Id equals b.Document_Id
                        where a.Answer_Id == this.Answer_Id
                        select b;
            return NewRs;
        }
    }
}