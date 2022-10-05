using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace CSETWebCore.DataLayer.Model
{
    public partial class DOCUMENT_FILE
    {
        public IQueryable<ANSWER> ANSWERs(CSETContext context)
        {
            var NewRs = from a in context.ANSWER
                        join b in context.DOCUMENT_ANSWERS on a.Answer_Id equals b.Answer_Id
                        where b.Document_Id == this.Document_Id
                        select a;
            return NewRs;
        }
    }
}